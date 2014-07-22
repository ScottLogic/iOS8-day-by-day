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

public class BetterMovingAverageCalculator: MovingAverageCalculator {
  
  public var windowSize: Int
  
  public init() {
    windowSize = 1
  }
  
  public func calculateMovingAverage(data: [Double]) -> [Double] {
    var result = [Double]()
    
    // Bail out if we don't have enough data
    if(data.count < windowSize) {
      return result
    }
    
    var currentSum = data[0..<windowSize].reduce(0) { $0 + $1 }
    result.append(Double(currentSum) / Double(windowSize))
    for i in 0..<(data.count - windowSize) {
      // Remove the first entry
      currentSum -= data[i]
      // And add the new one
      currentSum += data[i + windowSize]
      // Save it off
      result.append(Double(currentSum) / Double(windowSize))
    }
    
    return result
  }
  
}