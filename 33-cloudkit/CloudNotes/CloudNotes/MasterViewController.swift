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
import CloudKit

class MasterViewController: UITableViewController, NoteEditingDelegate {
  
  var loadingOverlay: LoadingOverlay!
  
  let noteManager = CloudKitNoteManager(database: CKContainer.defaultContainer().privateCloudDatabase)
  var noteCollection: [Note] = [Note]() {
    didSet {
      dispatch_async(dispatch_get_main_queue()) {
        self.tableView.reloadData()
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
      self.clearsSelectionOnViewWillAppear = false
      self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Grab the existing notes
    noteManager.getSummaryOfNotes {
      notes in
      self.noteCollection = notes
      self.showOverlay(false)
    }
    
    // Add an edit button
    self.navigationItem.leftBarButtonItem = self.editButtonItem()
    
    loadingOverlay = LoadingOverlay(frame: view.bounds)
    view.addSubview(loadingOverlay)
    
    let topCons = NSLayoutConstraint(item: loadingOverlay, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0)
    let leftCons = NSLayoutConstraint(item: loadingOverlay, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0)
    let bottomCons = NSLayoutConstraint(item: loadingOverlay, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0)
    let rightCons = NSLayoutConstraint(item: loadingOverlay, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0)
    NSLayoutConstraint.activateConstraints([topCons, leftCons, bottomCons, rightCons])
  }
  
  // MARK: - Segues
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showDetail" {
      if let indexPath = self.tableView.indexPathForSelectedRow() {
        let note = noteCollection[indexPath.row]
        let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
        controller.noteManager = noteManager
        controller.noteID = note.id
        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
        controller.navigationItem.leftItemsSupplementBackButton = true
      }
    } else if segue.identifier == "addNote" {
      let newNoteVC = segue.destinationViewController as NoteEditViewController
      newNoteVC.noteEditingDelegate = self
    }
  }
  
  // MARK: - Table View
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return noteCollection.count ?? 0
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
    
    let note = noteCollection[indexPath.row]
    cell.textLabel?.text = note.title
    cell.detailTextLabel?.text = "\(note.createdAt)"
    return cell
  }
  
  override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
    return .Delete
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      let note = noteCollection[indexPath.row]
      noteManager.deleteNote(note, callback: { success in
        if success {
          dispatch_async(dispatch_get_main_queue()) {
            var newCollection = self.noteCollection
            newCollection.removeAtIndex(indexPath.row)
            self.noteCollection = newCollection
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
          }
        }
      })
    }
  }
  
  // MARK: - NoteEditingDelegate
  func completedEditingNote(note: Note) {
    dismissViewControllerAnimated(true, completion: nil)
    showOverlay(true)
    noteManager.createNote(note) {
      (success, newNote) in
      self.showOverlay(false)
      if let newNote = newNote {
        let newCollection = self.noteCollection + [newNote]
        self.noteCollection = newCollection
      }
    }
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

