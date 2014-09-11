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
import Photos

class VideoListTableViewController: UITableViewController {
  
  var videos: PHFetchResult! = nil
  let imageManager = PHImageManager.defaultManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    videos = PHAsset.fetchAssetsWithMediaType(.Video, options: nil)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    if segue.identifier == "showVideoDetail" {
      if let detailVC = segue.destinationViewController as? VideoDetailViewController {
        let indexPath = tableView.indexPathForSelectedRow()
        if let indexPath = indexPath {
          detailVC.videoAsset = videos[indexPath.row] as? PHAsset
        }
      }
    }
  }
  
  // MARK: - Table view data source
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // Return the number of sections.
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Return the number of rows in the section.
    return videos?.count ?? 0
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("VideoCell", forIndexPath: indexPath) as VideoTableViewCell
    
    // Configure the cell...
    cell.imageManager = imageManager
    cell.videoAsset = videos[indexPath.row] as? PHAsset
    return cell
  }
  
}
