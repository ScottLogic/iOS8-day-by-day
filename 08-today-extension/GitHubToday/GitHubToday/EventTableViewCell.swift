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

class EventTableViewCell: UITableViewCell {
  
  @IBOutlet weak var iconLabel: UILabel!
  @IBOutlet weak var repoLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  var event: GitHubEvent? {
  didSet {
    if let event = event {
      iconLabel.text = event.eventType.icon
      repoLabel.text = event.repoName
      dateLabel.text = "\(event.time!)"
    }
  }
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if selected {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC)), dispatch_get_main_queue()) {
        self.setSelected(false, animated: true)
      }
    }
  }
  
}
