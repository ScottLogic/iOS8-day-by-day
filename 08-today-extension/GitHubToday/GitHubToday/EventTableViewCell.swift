//
//  EventTableViewCell.swift
//  GitHubToday
//
//  Created by Sam Davies on 11/07/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
  
  @IBOutlet var iconLabel: UILabel
  @IBOutlet var repoLabel: UILabel
  @IBOutlet var dateLabel: UILabel
  
  var event: GitHubEvent? {
  didSet {
    if let event = event {
      iconLabel.text = iconForEventType(event.eventType)
      repoLabel.text = event.repoName
      dateLabel.text = "\(event.time)"
    }
  }
  }
  
  func iconForEventType(eventType: GitHubEventType) -> String {
    switch eventType {
    case .Create:
      return ""
    case .Delete:
      return ""
    case .Follow:
      return ""
    case .Fork:
      return ""
    case .IssueComment:
      return ""
    case .Issues:
      return ""
    case .Other:
      return ""
    case .Push:
      return ""
    case .Watch:
      return ""
    default:
      return ""
    }
  }
  
}
