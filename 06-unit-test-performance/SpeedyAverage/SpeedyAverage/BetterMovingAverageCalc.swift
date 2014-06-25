//
//  BetterMovingAverageCalc.swift
//  SpeedyAverage
//
//  Created by Sam Davies on 25/06/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

import Foundation

class BetterMovingAverageCalculator: MovingAverageCalculator {
  
  var windowSize: Int
  
  init() {
    windowSize = 1
  }
  
  func calculateMovingAverage(data: Double[]) -> Double[] {
    var result = Double[]()
    
    // Bail out if we don't have enough data
    if(data.count < windowSize) {
      return result
    }
    
    var currentSum = data[0..windowSize].reduce(0) { $0 + $1 }
    result.append(Double(currentSum) / Double(windowSize))
    for i in 0..(data.count - windowSize) {
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