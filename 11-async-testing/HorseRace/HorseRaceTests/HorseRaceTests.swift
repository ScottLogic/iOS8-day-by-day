//
//  HorseRaceTests.swift
//  HorseRaceTests
//
//  Created by Sam Davies on 27/06/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

import XCTest
import HorseRace
import UIKit

class HorseRaceTests: XCTestCase {
  
  var viewController: ViewController!
  var raceController: TwoHorseRaceController!
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // Get hold of the view controller
    let window = UIApplication.sharedApplication().delegate.window!
    viewController = window.rootViewController as? ViewController
    raceController = viewController.raceController
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    viewController.raceController.reset()
    super.tearDown()
  }
  
  func testBasicAsyncMethod() {
    // Check that we get called back as expected
    let expectation = expectationWithDescription("Async Method")
    
    raceController.someKindOfAsyncMethod({
      expectation.fulfill()
      })
    
    waitForExpectationsWithTimeout(5, handler: nil)
  }
  
  
  func testRaceCallbacks() {
    // The horse race controller should callback each time a horse completes
    // the race.
    let h1Expectation = expectationWithDescription("Horse 1 should complete")
    let h2Expectation = expectationWithDescription("Horse 2 should complete")
    
    raceController.startRace(3, horseCrossedLineCallback: {
      (horse: Horse) in
      switch horse.horseView {
      case self.viewController.horse1:
        h1Expectation.fulfill()
      case self.viewController.horse2:
        h2Expectation.fulfill()
      default:
        XCTFail("Completetion called with unknown horse")
      }
    })
    
    waitForExpectationsWithTimeout(5, handler: nil)
  }
  
  func testResetButtonEnabledOnceRaceComplete() {
    let expectation = keyValueObservingExpectationForObject(viewController.resetButton, keyPath: "enabled", expectedValue: true)
    
    // Simulate tapping the start race button
    viewController.handleStartRaceButton(viewController.startRaceButton)
    
    // Wait for the test to run
    waitForExpectationsWithTimeout(5, handler: nil)
  }
  
  
}
