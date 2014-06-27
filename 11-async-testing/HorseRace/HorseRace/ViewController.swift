//
//  ViewController.swift
//  HorseRace
//
//  Created by Sam Davies on 27/06/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  
  @IBOutlet var horse1: UIImageView
  @IBOutlet var horse2: UIImageView
  @IBOutlet var horse1StartConstraint: NSLayoutConstraint
  @IBOutlet var horse2StartConstraint: NSLayoutConstraint
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

