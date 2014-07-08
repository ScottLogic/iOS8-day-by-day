//
//  ViewController.swift
//  ShareAlike
//
//  Created by Sam Davies on 13/06/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  
  @IBOutlet var sharingContentImageView: UIImageView
  
  @IBAction func handleShareSampleTapped(sender: AnyObject) {
    shareContent(sharingText: "Highland Cow", sharingImage: sharingContentImageView.image)
  }
  
  // Utility methods
  func shareContent(#sharingText: String?, sharingImage: UIImage?) {
    var itemsToShare = [AnyObject]()
    
    if let text = sharingText {
      itemsToShare.append(text)
    }
    if let image = sharingImage {
      itemsToShare.append(image)
    }
    
    let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
    presentViewController(activityViewController, animated: true, completion: nil)
  }
  
}

