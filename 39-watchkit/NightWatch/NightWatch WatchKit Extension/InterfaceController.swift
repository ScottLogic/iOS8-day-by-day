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
  var timer: NSTimer?
  let quoteCycleTime: NSTimeInterval = 30
  
  @IBOutlet weak var quoteLabel: WKInterfaceLabel!
  @IBOutlet weak var quoteChangeTimer: WKInterfaceTimer!
  
  override func awakeWithContext(context: AnyObject!) {
    if quotes.count != 5 {
      quotes = quoteGenerator.randomQuotes(5)
    }
    quoteLabel.setText(quotes[currentQuote])
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
    
    timer?.invalidate()
    timer = NSTimer.scheduledTimerWithTimeInterval(quoteCycleTime, target: self, selector: "fireTimer:", userInfo: nil, repeats: true)
    quoteChangeTimer.setDate(NSDate(timeIntervalSinceNow: quoteCycleTime))
    quoteChangeTimer.start()
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    timer?.invalidate()
    super.didDeactivate()
  }
  
  
  @IBAction func handleSkipButtonPressed() {
    timer?.fire()
    timer?.invalidate()
    timer = NSTimer.scheduledTimerWithTimeInterval(quoteCycleTime, target: self, selector: "fireTimer:", userInfo: nil, repeats: true)
  }
  
  @objc func fireTimer(t: NSTimer) {
    currentQuote = (currentQuote + 1) % quotes.count
    quoteLabel.setText(quotes[currentQuote])
    quoteChangeTimer.setDate(NSDate(timeIntervalSinceNow: quoteCycleTime))
    quoteChangeTimer.start()
  }
  
}
