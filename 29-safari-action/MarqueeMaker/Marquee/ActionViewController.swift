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
import MobileCoreServices

class ActionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!

  
  var tagList = [TagStatus]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Populate the tag map
    tagList = createTagList()
    
    
    // Get the item[s] we're handling from the extension context.
    
    // For example, look for an image and place it into an image view.
    // Replace this with something appropriate for the type[s] your extension supports.
  }

  
  @IBAction func done() {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    self.extensionContext!.completeRequestReturningItems(self.extensionContext!.inputItems, completionHandler: nil)
  }
  
  @IBAction func cancel(sender: AnyObject) {
    let error = NSError(domain: "errorDomain", code: 0, userInfo: nil)
    self.extensionContext!.cancelRequestWithError(error)
  }
  
  
  // MARK:- UITableViewDataSource
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tagList.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("tagTypeCell", forIndexPath: indexPath) as UITableViewCell
    let tag = tagList[indexPath.row]
    cell.textLabel?.text = tag.name
    cell.accessoryType = tag.status ? .Checkmark : .None
    return cell
  }
  
  // MARK:- UITableViewDelegate
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var tag = tagList[indexPath.row]
    tag.toggleStatus()
    if let cell = tableView.cellForRowAtIndexPath(indexPath) {
      cell.accessoryType = tag.status ? .Checkmark : .None
      cell.selected = false
    }
  }

  
  // MARK:- Utility Methods
  private func createTagList() -> [TagStatus] {
    return ["h1", "h2", "h3", "h4", "p"].map { TagStatus(name: $0) }
  }
  
  
}
