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

class NaiveMovingAverageCalculator: MovingAverageCalculator {
  
  var windowSize: Int
  
  init() {
    windowSize = 1
  }
  
  func calculateMovingAverage(data: Double[]) -> Double[] {
    // Create an array to store the result
    var result = Double[]()
    
    if(data.count < windowSize) {
      return result
    }
    
    // Now perform the calculation
    for i in 0...(data.count - windowSize) {
      let slice = data[i..(i+windowSize)]
      let partialSum = slice.reduce(0) { $0 + $1 }
      result.append(Double(partialSum) / Double(windowSize))
    }
    
    return result
  }
}