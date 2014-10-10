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
  
  let noteManager = CloudKitNoteManager(database: CKContainer.defaultContainer().privateCloudDatabase)
  var noteCollection: [Note] = [Note]() {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
      self.clearsSelectionOnViewWillAppear = false
      self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    checkForICloud()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Grab the existing notes
    noteManager.getSummaryOfNotes { self.noteCollection = $0 }
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
      if let navVC = segue.destinationViewController as? UINavigationController {
        let newNoteVC = navVC.topViewController as NoteEditViewController
        newNoteVC.noteEditingDelegate = self
      }
      
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
    return cell
  }
  
  // MARK: - NoteEditingDelegate
  func completedEditingNote(note: Note) {
    noteManager.createNote(note)
    dismissViewControllerAnimated(true, completion: {
      println(self.navigationController?.viewControllers)
      })
    let newCollection = noteCollection + [note]
    noteCollection = newCollection
  }
  
  // MARK: - Utility methods
  func checkForICloud() {
    let iCloudToken = NSFileManager.defaultManager().ubiquityIdentityToken
    if iCloudToken == nil {
      let alertView = UIAlertController(title: "iCloud", message: "You should sign in to an iCloud account to enable full use of this app", preferredStyle: .Alert)
      alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
        _ in
        self.dismissViewControllerAnimated(true, completion: nil)
      }))
      presentViewController(alertView, animated: true, completion: nil)
    }
  }
  
}

