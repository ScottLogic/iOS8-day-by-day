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
import GitHubTodayCommon

class TableViewController: UITableViewController {

  let dataProvider = GitHubDataProvider()
  let mostRecentEventCache = GitHubEventCache(userDefaults: NSUserDefaults(suiteName: "group.GitHubToday")!)
  var events: [GitHubEvent] = [GitHubEvent]() {
  didSet {
    // Must call reload on the main thread
    dispatch_async(dispatch_get_main_queue()) {
      self.tableView.reloadData()
    }
  }
  }
  
  override func awakeFromNib() {
    title = "GitHub Events"
    dataProvider.getEvents("sammyd", callback: {
      githubEvents in
      self.events = githubEvents
      self.mostRecentEventCache.mostRecentEvent = githubEvents[0]
      })
  }
  
  func scrollToAndHighlightEvent(eventId: Int) {
    var eventIndex: Int? = nil
    for (index, event) in enumerate(events) {
      if event.id == eventId {
        eventIndex = index
        break
      }
    }
    if let eventIndex = eventIndex {
      let indexPath = NSIndexPath(forRow: eventIndex, inSection: 0)
      tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Top)
    }
  }
  
  
  // DataSource
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let count = events.count
    return count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! UITableViewCell
  }
  
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if let eventCell = cell as? EventTableViewCell {
      let event = events[indexPath.row]
      eventCell.event = event
    }
  }
  
  
}
