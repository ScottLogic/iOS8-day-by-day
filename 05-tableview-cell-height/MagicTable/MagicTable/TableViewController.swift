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

class TableViewController: UITableViewController {

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
        cell.customFontLabel!.text = "Cell \(indexPath.row)"
        cell.customFontLabel!.font = cell.customFontLabel!.font.fontWithSize(CGFloat(indexPath.row) * 4.0)
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
