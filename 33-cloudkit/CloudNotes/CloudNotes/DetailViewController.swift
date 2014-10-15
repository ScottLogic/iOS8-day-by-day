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
  
  var loadingOverlay: LoadingOverlay!
  
  var noteManager: NoteManager?
  
  var noteID: String? {
    didSet {
      // Request the full note content
      if let noteID = noteID {
        showOverlay(true)
        noteManager?.getNote(noteID) {
          note in
          self.note = note
          self.showOverlay(false)
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
      if let location = note.location {
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        self.mapView.centerCoordinate = location.coordinate
        self.mapView.addAnnotation(pin)
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.configureView()
    
    loadingOverlay = LoadingOverlay(frame: view.bounds)
    view.addSubview(loadingOverlay)
    
    let topCons = NSLayoutConstraint(item: loadingOverlay, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0)
    let leftCons = NSLayoutConstraint(item: loadingOverlay, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0)
    let bottomCons = NSLayoutConstraint(item: loadingOverlay, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0)
    let rightCons = NSLayoutConstraint(item: loadingOverlay, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0)
    NSLayoutConstraint.activateConstraints([topCons, leftCons, bottomCons, rightCons])
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
    self.showOverlay(true)
    noteManager?.updateNote(note, callback: {
      success in
      self.note = note
      self.showOverlay(false)
    })
    navigationController?.popViewControllerAnimated(true)
  }
  
  // MARK: - Utility methods
  private func showOverlay(show: Bool) {
    dispatch_async(dispatch_get_main_queue()) {
      UIView.animateWithDuration(0.5) {
        self.loadingOverlay.alpha = show ? 1.0 : 0.0
      }
    }
  }
}

