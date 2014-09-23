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
    
    for item: AnyObject in self.extensionContext!.inputItems {
      let inputItem = item as NSExtensionItem
      for provider: AnyObject in inputItem.attachments! {
        let itemProvider = provider as NSItemProvider
        if itemProvider.hasItemConformingToTypeIdentifier(kUTTypePropertyList as NSString) {
          // You _HAVE_ to call loadItemForTypeIdentifier in order to get the JS injected
          itemProvider.loadItemForTypeIdentifier(kUTTypePropertyList as NSString, options: nil, completionHandler: {
            (list, error) in
            if let results = list as? NSDictionary {
              NSOperationQueue.mainQueue().addOperationWithBlock {
                // We don't actually care about this...
                println(results)
              }
            }
          })
        }
      }
    }

  }

  
  @IBAction func done() {
    // Find out which tags need marqueefying
    let marqueeTagNames = tagList.filter{ $0.status }.map{ $0.tag }
    
    // Parcel them up in an NSExtensionItem
    let extensionItem = NSExtensionItem()
    let jsDict = [ NSExtensionJavaScriptFinalizeArgumentKey : [ "marqueeTagNames" : marqueeTagNames ]]
    extensionItem.attachments = [ NSItemProvider(item: jsDict, typeIdentifier: kUTTypePropertyList as NSString)]
    
    // Send them back to the javascript processor
    self.extensionContext!.completeRequestReturningItems([extensionItem], completionHandler: nil)
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
    cell.textLabel?.text = "\(tag)"
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
    return [("Heading 1", "h1"),
            ("Heading 2", "h2"),
            ("Heading 3", "h3"),
            ("Heading 4", "h4"),
            ("Paragraph", "p")].map { (name: String, tag: String) in TagStatus(tag: tag,name: name) }
  }
  
  
}
