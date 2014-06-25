//
//  NaiveMovingAverageCalc.swift
//  SpeedyAverage
//
//  Created by Sam Davies on 25/06/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
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