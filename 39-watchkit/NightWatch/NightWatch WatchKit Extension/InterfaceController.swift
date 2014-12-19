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

import WatchKit
import Foundation
import NightWatchData


class InterfaceController: WKInterfaceController {
  
  var quotes = [Quote]()
  var currentQuote: Int = 0
  let quoteGenerator = NightWatchQuotes()
  
  @IBOutlet weak var quoteLabel: WKInterfaceLabel!
  
  override func awakeWithContext(context: AnyObject!) {
    if quotes.count != 5 {
      quotes = quoteGenerator.randomQuotes(5)
    }
    quoteLabel.setText(quotes[currentQuote])
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
    NSLog("%@ will activate", self)
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    NSLog("%@ did deactivate", self)
    super.didDeactivate()
  }
  
}
