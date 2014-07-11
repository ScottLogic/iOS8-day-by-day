//
//  TableViewController.swift
//  GitHubToday
//
//  Created by Sam Davies on 11/07/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

import UIKit
import GitHubTodayCommon

class TableViewController: UITableViewController {

  let dataProvider = GitHubDataProvider()
  let mostRecentEventCache = GitHubEventCache(userDefaults: NSUserDefaults(suiteName: "group.GitHubToday"))
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
  override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
    let count = events.count
    return count
  }
  
  override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
    return tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as UITableViewCell
  }
  
  override func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!) {
    if let eventCell = cell as? EventTableViewCell {
      let event = events[indexPath.row]
      eventCell.event = event
    }
  }
  
  
}
