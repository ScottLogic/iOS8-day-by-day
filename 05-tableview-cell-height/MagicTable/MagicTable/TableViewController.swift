//
//  TableViewController.swift
//  MagicTable
//
//  Created by Sam Davies on 25/06/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

  // Datasource methods
  override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
    return 1;
  }
  
  override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
    return 20;
  }
  
  override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
    if let cell = tableView.dequeueReusableCellWithIdentifier("RightDetailCell", forIndexPath: indexPath) as? UITableViewCell {
      cell.detailTextLabel!.text = "\(indexPath.section),\(indexPath.row)"
      cell.textLabel!.text = "Cell \(indexPath.row)"
      return cell
    }
    return nil
  }
  
  override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
    switch section {
    case 0:
      return "Autosizing for Free!"
    default:
      return ""
    }
  }
  
}
