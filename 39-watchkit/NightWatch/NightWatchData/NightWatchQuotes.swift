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

public typealias Quote = String

public class NightWatchQuotes {
  
  private var quotes = [Quote]()
  
  public init(array: [String]) {
    quotes = array
  }
  
  public convenience init(plistName: String) {
    let bundle = NSBundle(identifier: "com.shinobicontrols.NightWatchData")
    
    let path = bundle!.pathForResource("NightWatchQuotes", ofType: "plist")
    if let array = NSArray(contentsOfFile: path!) as? [String] {
      self.init(array: array)
    } else {
      self.init(array: [Quote]())
    }
  }
  
  public convenience init() {
    self.init(plistName: "NightWatchQuotes")
  }
  
  public func randomQuote() -> Quote {
    let rnd = Int(arc4random_uniform(UInt32(quotes.count)))
    return quotes[rnd]
  }
  
  public func randomQuotes(number: Int) -> [Quote] {
    var quoteList = [Quote]()
    while quoteList.count < number {
      quoteList += [randomQuote()]
    }
    return quoteList
  }
  
}
