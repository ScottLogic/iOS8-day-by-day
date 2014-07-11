//
//  EventTableViewCell.swift
//  GitHubToday
//
//  Created by Sam Davies on 11/07/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

import UIKit
import GitHubTodayCommon

class EventTableViewCell: UITableViewCell {
  
  @IBOutlet var iconLabel: UILabel
  @IBOutlet var repoLabel: UILabel
  @IBOutlet var dateLabel: UILabel
  
  var event: GitHubEvent? {
  didSet {
    if let event = event {
      iconLabel.text = event.eventType.icon
      repoLabel.text = event.repoName
      dateLabel.text = "\(event.time)"
    }
  }
  }
  
}
