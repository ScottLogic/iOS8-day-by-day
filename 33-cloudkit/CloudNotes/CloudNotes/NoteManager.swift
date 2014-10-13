//
// Copyright 2014 Scott Logic
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import CoreLocation
import CloudKit


protocol NoteManager {
  func createNote(note: Note, callback: ((success: Bool, note: Note?) -> ())?)
  func getSummaryOfNotes(callback: (notes: [Note]) -> ())
  func getNote(noteID: String, callback: (Note) -> ())
  func updateNote(note: Note, callback: ((success: Bool) -> ())?)
  func deleteNote(note: Note, callback: ((success: Bool) -> ())?)
}


class CloudKitNoteManager: NoteManager {
  let database: CKDatabase
  
  init(database: CKDatabase) {
    self.database = database
  }
  
  func createNote(note: Note, callback:((success: Bool, note: Note?) -> ())?) {
    let ckNote = CloudKitNote(note: note)
    database.saveRecord(ckNote.record) { (record, error) in
      if error != nil {
        println("There was an error: \(error)")
        callback?(success: false, note: nil)
      } else {
        println("Record saved successfully")
        callback?(success: true, note: ckNote)
      }
    }
  }
  
  func getSummaryOfNotes(callback: (notes: [Note]) -> ()) {
    // Get a list of all notes. Only some keys populated tho
    let query = CKQuery(recordType: "Note", predicate: NSPredicate(value: true))
    let queryOperation = CKQueryOperation(query: query)
    queryOperation.desiredKeys = ["title"]
    var records = [Note]()
    queryOperation.recordFetchedBlock = { record in records.append(CloudKitNote(record: record)) }
    queryOperation.queryCompletionBlock = { _ in callback(notes: records) }
    
    database.addOperation(queryOperation)
    
  }
  
  func updateNote(note: Note, callback:((success: Bool) -> ())?) {
    // This the more specific version is preferred
    let cloudKitNote = CloudKitNote(note: note)
    updateNote(cloudKitNote, callback: callback)
  }
  
  func updateNote(note: CloudKitNote, callback:((success: Bool) -> ())?) {
    // Some here to save it
    let updateOperation = CKModifyRecordsOperation(recordsToSave: [note], recordIDsToDelete: nil)
    updateOperation.perRecordCompletionBlock = { record, error in
      if error != nil {
        // Really important to handle this here
        println("Unable to modify record: \(record). Error: \(error)")
      }
    }
    updateOperation.modifyRecordsCompletionBlock = { saved, _, error in
      if error != nil {
        if error.code == CKErrorCode.PartialFailure.toRaw() {
          println("There was a problem completing the operation. The following records had problems: \(error.userInfo?[CKPartialErrorsByItemIDKey])")
        }
        callback?(success: false)
      } else {
        callback?(success: true)
      }
    }
    database.addOperation(updateOperation)
  }
  
  func deleteNote(note: Note, callback: ((success: Bool) -> ())?) {
    let deleteOperation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [CKRecordID(recordName: note.id)])
    deleteOperation.perRecordCompletionBlock = { record, error in
      if error != nil {
        println("Unable to delete record: \(record). Error: \(error)")
      }
    }
    deleteOperation.modifyRecordsCompletionBlock = { _, deleted, error in
      if error != nil {
        if error.code == CKErrorCode.PartialFailure.toRaw() {
          println("There was a problem completing the operation. The following records had problems: \(error.userInfo?[CKPartialErrorsByItemIDKey])")
        }
        callback?(success: false)
      }
      callback?(success: true)
    }
    database.addOperation(deleteOperation)
  }
  
  func getNote(noteID: String, callback: (Note) -> ()) {
    let recordID = CKRecordID(recordName: noteID)
    database.fetchRecordWithID(recordID) {
      (record, error) in
      if error != nil {
        println("There was an error: \(error)")
      } else {
        let note = CloudKitNote(record: record)
        callback(note)
      }
    }
  }
}



