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

import Foundation


@objc public class GitHubEvent: NSObject, Printable, Equatable, NSCoding {
  public var id: Int
  public var eventType: GitHubEventType
  public var repoName: String?
  public var time: NSDate?
  private class var dateFormatter : NSDateFormatter {
  struct Static {
    static let instance : NSDateFormatter = NSDateFormatter()
    }
    return Static.instance
  }
  
  public init(id: Int, eventType: GitHubEventType, repoName: String?, time: NSDate?) {
    self.id = id
    self.eventType = eventType
    self.repoName = repoName
    self.time = time
  }
  
  // NSCoding
  public required init(coder aDecoder: NSCoder) {
    self.id = aDecoder.decodeIntegerForKey("id")
    self.eventType = GitHubEventType.fromRaw(aDecoder.decodeObjectForKey("eventType") as String)!
    self.repoName = aDecoder.decodeObjectForKey("repoName") as? String
    self.time = aDecoder.decodeObjectForKey("time") as? NSDate
  }
  
  public func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeInteger(id, forKey: "id")
    aCoder.encodeObject(eventType.toRaw(), forKey: "eventType")
    aCoder.encodeObject(repoName!, forKey: "repoName")
    aCoder.encodeObject(time!, forKey: "time")
  }
  
  public convenience init(json: JSONValue) {
    let data = GitHubEvent.extractDataFromJson(json)
    self.init(id: data.id, eventType: data.eventType, repoName: data.repoName, time: data.time)
  }
  
  
  public class func extractDataFromJson(jsonEvent: JSONValue) -> (id: Int, eventType: GitHubEventType, repoName: String?, time: NSDate?) {
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
  override public var description: String {
    return "[\(id)] \(time) : \(eventType.toRaw()) \(repoName)"
  }
}

// Equatable
public func ==(lhs: GitHubEvent, rhs: GitHubEvent) -> Bool {
  return lhs.id == rhs.id
}

public enum GitHubEventType: String {
  case Create = "create"
  case Delete = "delete"
  case Fork = "fork"
  case Push = "push"
  case Watch = "watch"
  case Follow = "follow"
  case Issues = "issues"
  case IssueComment = "comment"
  case Other = "other"
  
  public var icon: String {
    switch self {
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


public class GitHubDataProvider {
  
  public init() { }
  
  public func getEvents(user: String, callback: ([GitHubEvent])->()) {
    let url = NSURL(string: "https://api.github.com/users/\(user)/events")
    let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {
      (data, response, error) in
      if (error != nil) {
        println("Error: \(error.localizedDescription)")
        return
      }
      let events = self.convertJSONToEvents(JSONValue(data))
      callback(events)

      })
    task.resume()
  }
  
  private func convertJSONToEvents(data: JSONValue) -> [GitHubEvent] {
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

let mostRecentEventCacheKey = "GitHubToday.mostRecentEvent"

public class GitHubEventCache {
  private var userDefaults: NSUserDefaults
  
  public init(userDefaults: NSUserDefaults) {
    self.userDefaults = userDefaults
  }
  
  public var mostRecentEvent: GitHubEvent? {
  get {
    if let data = userDefaults.objectForKey(mostRecentEventCacheKey) as? NSData {
      if let event = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? GitHubEvent {
        return event
      }
    }
    return nil
  }
  set(newEvent) {
    if let event = newEvent {
      let data = NSKeyedArchiver.archivedDataWithRootObject(event)
      userDefaults.setObject(data, forKey: mostRecentEventCacheKey)
    } else {
      userDefaults.removeObjectForKey(mostRecentEventCacheKey)
    }
  }
  }
  
}