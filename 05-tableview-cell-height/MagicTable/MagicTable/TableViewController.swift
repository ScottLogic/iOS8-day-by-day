//
//  TableViewController.swift
//  MagicTable
//
//  Created by Sam Davies on 25/06/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
  
  override func viewDidLoad() {
    tableView.rowHeight = 44
  }

  // Datasource methods
  override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
    return 2;
  }
  
  override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
    return 20;
  }
  
  override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
    switch indexPath.section {
    case 0:
      if let cell = tableView.dequeueReusableCellWithIdentifier("RightDetailCell", forIndexPath: indexPath) as? UITableViewCell {
        cell.detailTextLabel!.text = "\(indexPath.section),\(indexPath.row)"
        cell.textLabel!.text = "Cell \(indexPath.row)"
        return cell
      }
    case 1:
      if let cell = tableView.dequeueReusableCellWithIdentifier("CustomFontCell", forIndexPath: indexPath) as? CustomFontCell {
        cell.customFontLabel.text = "Cell \(indexPath.row)"
        cell.customFontLabel.font = cell.customFontLabel.font.fontWithSize(Float(indexPath.row) * 4.0)
        return cell
      }
    default:
      return nil
    }
    return nil
  }
  
  override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
    switch section {
    case 0:
      return "Autosizing for Free!"
    case 1:
      return "Custom Font"
    default:
      return ""
    }
  }
  
}
