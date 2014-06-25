//
//  MovingAverageProtocol.swift
//  SpeedyAverage
//
//  Created by Sam Davies on 25/06/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

import Foundation

protocol MovingAverageCalculator {
  // The length of the window
  var windowSize: Int { get set }
  
  // Calculate the moving average on for the given data set
  func calculateMovingAverage(data: Double[]) -> Double[]
}