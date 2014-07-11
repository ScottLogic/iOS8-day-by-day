//
//  GitHubDataProvider.swift
//  GitHubToday
//
//  Created by Sam Davies on 10/07/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

import Foundation


class GitHubEvent: Printable, Equatable {
  var id: Int
  var eventType: GitHubEventType
  var repoName: String?
  var time: NSDate?
  class var dateFormatter : NSDateFormatter {
  struct Static {
    static let instance : NSDateFormatter = NSDateFormatter()
    }
    return Static.instance
  }
  
  init(id: Int, eventType: GitHubEventType, repoName: String?, time: NSDate?) {
    self.id = id
    self.eventType = eventType
    self.repoName = repoName
    self.time = time
  }
  
  convenience init(json: JSONValue) {
    let data = GitHubEvent.extractDataFromJson(json)
    self.init(id: data.id, eventType: data.eventType, repoName: data.repoName, time: data.time)
  }
  
  
  class func extractDataFromJson(jsonEvent: JSONValue) -> (id: Int, eventType: GitHubEventType, repoName: String?, time: NSDate?) {
    let id = jsonEvent["id"].integer!
    var repoName: String? = nil
    if let repo = jsonEvent["repo"].object {
      repoName = repo["name"]?.string
    }
    var eventType: GitHubEventType = .Other
    if let eventString = jsonEvent["type"].string {
      switch eventString {
        case "CreateEvent":
        eventType = .Create
      case "DeleteEvent":
        eventType = .Delete
      case "ForkEvent":
        eventType = .Fork
      case "PushEvent":
        eventType = .Push
      case "WatchEvent":
        eventType = .Watch
      case "FollowEvent":
        eventType = .Follow
      case "IssuesEvent":
        eventType = .Issues
      case "IssueCommentEvent":
        eventType = .IssueComment
      default:
        eventType = .Other
      }
    }
    
    var date: NSDate?
    if let createdString = jsonEvent["created_at"].string {
      GitHubEvent.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      date = GitHubEvent.dateFormatter.dateFromString(createdString)
    }
    
    return (id, eventType, repoName, date)
  }
  
  // Printable
  var description: String {
    return "[\(id)] \(time) : \(eventType.toRaw()) \(repoName)"
  }
}

// Equatable
func ==(lhs: GitHubEvent, rhs: GitHubEvent) -> Bool {
  return lhs.id == rhs.id
}

enum GitHubEventType: String {
  case Create = "create"
  case Delete = "delete"
  case Fork = "fork"
  case Push = "push"
  case Watch = "watch"
  case Follow = "follow"
  case Issues = "issues"
  case IssueComment = "comment"
  case Other = "other"
}


class GitHubDataProvider {
  
  func getEvents(user: String, callback: ([GitHubEvent])->()) {
    let url = NSURL(string: "https://api.github.com/users/\(user)/events")
    let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {
      (data, response, error) in
      if error {
        println("Error: \(error.localizedDescription)")
        return
      }
      let events = self.convertJSONToEvents(JSONValue(data))
      callback(events)

      })
    task.resume()
  }
  
  func convertJSONToEvents(data: JSONValue) -> [GitHubEvent] {
    let json = data.array
    var ghEvents = [GitHubEvent]()
    if let events = json {
      for event in events {
        let ghEvent = GitHubEvent(json: event)
        ghEvents.append(ghEvent)
      }
    }
    return ghEvents
  }
  
}