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
import CloudKit


protocol Note {
  var id: String? { get }
  var title: String { get set }
  var content: String? { get set }
  var location: CLLocation? { get set }
  var createdAt: NSDate { get }
  var lastModifiedAt: NSDate { get }
}

class PrototypeNote: Note {
  var id: String?
  var title: String = ""
  var content: String?
  var location: CLLocation?
  var createdAt: NSDate = NSDate()
  var lastModifiedAt: NSDate = NSDate()
  
  init() { }
}


class CloudKitNote: Note {
  let record: CKRecord
  
  init(record: CKRecord) {
    self.record = record
  }
  
  init(note: Note) {
    record = CKRecord(recordType: "Note")
    title = note.title
    content = note.content
    location = note.location
  }
  
  var id: String? {
    return record.recordID.recordName
  }
  
  var title: String {
    get {
      return record.objectForKey("title") as String
    }
    set {
      record.setObject(newValue, forKey: "title")
    }
  }
  
  var content: String? {
    get {
      return record.objectForKey("content") as? String
    }
    set {
      record.setObject(newValue, forKey: "content")
    }
  }
  
  var location: CLLocation? {
    get {
      return record.objectForKey("location") as? CLLocation
    }
    set {
      record.setObject(newValue, forKey: "location")
    }
  }
  
  var createdAt: NSDate {
    return record.creationDate
  }
  
  var lastModifiedAt: NSDate {
    return record.modificationDate
  }
}