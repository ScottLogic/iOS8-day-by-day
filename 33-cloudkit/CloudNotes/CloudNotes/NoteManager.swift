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
  func createNote(note: Note)
  func getSummaryOfNotes(callback: (notes: [Note]) -> ())
  func getNote(noteID: String, callback: (Note) -> ())
}


class CloudKitNoteManager: NoteManager {
  let database: CKDatabase
  
  init(database: CKDatabase) {
    self.database = database
  }
  
  func createNote(note: Note) {
    let ckNote = CloudKitNote(note: note)
    database.saveRecord(ckNote.record) { (record, error) in
      if error != nil {
        println("There was an error: \(error)")
      } else {
        println("Record saved successfully")
      }
    }
  }
  
  func getSummaryOfNotes(callback: (notes: [Note]) -> ()) {
    //
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



