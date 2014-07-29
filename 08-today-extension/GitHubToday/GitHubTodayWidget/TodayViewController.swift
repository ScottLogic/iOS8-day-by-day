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
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
  
  @IBOutlet weak var typeLabel: UILabel!
  @IBOutlet weak var repoNameLabel: UILabel!
  
  let dataProvider = GitHubDataProvider()
  let mostRecentEventCache = GitHubEventCache(userDefaults: NSUserDefaults(suiteName: "group.GitHubToday"))
  var currentEvent: GitHubEvent? {
  didSet {
    dispatch_async(dispatch_get_main_queue()) {
      if let event = self.currentEvent {
        self.typeLabel.text = event.eventType.icon
        self.repoNameLabel.text = event.repoName
      } else {
        self.typeLabel.text = ""
        self.repoNameLabel.text = ""
      }
    }
  }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view from its nib.
    currentEvent = mostRecentEventCache.mostRecentEvent
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encoutered, use NCUpdateResult.Failed
    // If there's no update required, use NCUpdateResult.NoData
    // If there's an update, use NCUpdateResult.NewData
    
    dataProvider.getEvents("sammyd", callback: {
      events in
      let newestEvent = events[0]
      if newestEvent != self.currentEvent {
        self.currentEvent = newestEvent
        self.mostRecentEventCache.mostRecentEvent = newestEvent
        completionHandler(.NewData)
      } else {
        completionHandler(.NoData)
      }
      
      })
  }
  
  func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
    let newInsets = UIEdgeInsets(top: defaultMarginInsets.top, left: defaultMarginInsets.left-30,
                                 bottom: defaultMarginInsets.bottom, right: defaultMarginInsets.right)
    return newInsets
  }
  
  
  @IBAction func handleMoreButtonTapped(sender: AnyObject) {
    let url = NSURL(scheme: "githubtoday", host: nil, path: "/\(currentEvent?.id)")
    extensionContext.openURL(url, completionHandler: nil)
  }
  
}
