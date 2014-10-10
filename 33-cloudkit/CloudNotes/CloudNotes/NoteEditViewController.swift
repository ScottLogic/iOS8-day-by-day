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

protocol NoteEditingDelegate {
  func completedEditingNote(note: Note)
}


class NoteEditViewController: UIViewController {
 
  @IBOutlet weak var vcTitleLabel: UILabel!
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var contentTextView: UITextView!
  
  var note: Note? {
    didSet {
      configureView()
    }
  }
  
  var noteEditingDelegate: NoteEditingDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    configureView()
  }
  
  
  private func configureView() {
    if let note = note {
      vcTitleLabel?.text = "Edit Note"
      contentTextView?.text = note.content
      titleTextField?.text = note.title
    } else {
      vcTitleLabel?.text = ""
    }
  }
  
  @IBAction func handleDoneButtonPressed(sender: AnyObject) {
    var newValuesNote: Note = note ?? PrototypeNote()

    newValuesNote.title = titleTextField.text
    newValuesNote.content = contentTextView.text
    
    noteEditingDelegate?.completedEditingNote(newValuesNote)
    note = newValuesNote
  }
  
}
