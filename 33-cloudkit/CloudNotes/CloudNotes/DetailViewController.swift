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

import UIKit
import MapKit

class DetailViewController: UIViewController, NoteEditingDelegate {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!
  
  var noteManager: NoteManager?
  
  var noteID: String? {
    didSet {
      // Request the full note content
      if let noteID = noteID {
        noteManager?.getNote(noteID) {
          note in
          self.note = note
        }
      }
    }
  }
  
  private var note: Note? {
    didSet {
      dispatch_async(dispatch_get_main_queue()) {
        // Update the view.
        self.configureView()
      }
    }
  }

  private func configureView() {
    // Update the user interface for the detail item.
    if let note = note {
      titleLabel.text = note.title
      contentLabel.text = note.content 
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.configureView()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "editNote" {
      let editVC = segue.destinationViewController as NoteEditViewController
      editVC.noteEditingDelegate = self
      editVC.note = note
    }
  }
  
  // MARK:- NoteEditingDelegate
  func completedEditingNote(note: Note) {
    self.note = note
    noteManager?.updateNote(note, callback: nil)
    dismissViewControllerAnimated(true, completion: nil)
  }
}

