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

class MasterViewController: UITableViewController {

  var detailViewController: DetailViewController? = nil
  let noteManager = CloudKitNoteManager(database: CKContainer.defaultContainer().privateCloudDatabase)
  var noteCollection: [Note]? {
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

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem()

    let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
    self.navigationItem.rightBarButtonItem = addButton
    if let split = self.splitViewController {
        let controllers = split.viewControllers
        self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
    }
  }


  func insertNewObject(sender: AnyObject) {
    //objects.insertObject(NSDate.date(), atIndex: 0)
    //let indexPath = NSIndexPath(forRow: 0, inSection: 0)
    //self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
  }

  // MARK: - Segues

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showDetail" {
      if let indexPath = self.tableView.indexPathForSelectedRow() {
        if let note = noteCollection?[indexPath.row] {
          let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
          controller.note = note
          controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
          controller.navigationItem.leftItemsSupplementBackButton = true
        }
      }
    }
  }

  // MARK: - Table View

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return noteCollection?.count ?? 0
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

    if let note = noteCollection?[indexPath.row] {
      cell.textLabel?.text = note.title
    }
    return cell
  }

}

