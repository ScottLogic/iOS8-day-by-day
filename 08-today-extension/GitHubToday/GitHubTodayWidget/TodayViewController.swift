//
//  TodayViewController.swift
//  GitHubTodayWidget
//
//  Created by Sam Davies on 11/07/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

import UIKit
import GitHubTodayCommon
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
  
  @IBOutlet var typeLabel: UILabel
  @IBOutlet var repoNameLabel: UILabel
  
  let dataProvider = GitHubDataProvider()
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
      println("Back from network")
      let newestEvent = events[0]
      if newestEvent != self.currentEvent {
        self.currentEvent = newestEvent
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
}
