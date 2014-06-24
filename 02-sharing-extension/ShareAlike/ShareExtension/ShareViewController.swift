//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Sam Davies on 13/06/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import CoreGraphics


class ShareViewController: SLComposeServiceViewController {
  
  override func isContentValid() -> Bool {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return true
  }
  
  override func didSelectPost() {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    let configName = "com.shinobicontrols.ShareAlike.BackgroundSessionConfig"
    let sessionConfig = NSURLSessionConfiguration.backgroundSessionConfiguration(configName)
    let session = NSURLSession(configuration: sessionConfig)
    
    println(extensionContext.inputItems)
    println("HELLLLOOOOOO")
    
    // Only interested in the first item
    let extensionItem = extensionContext.inputItems[0] as NSExtensionItem
    
    let picDeets = pictureDetailsFromExtensionItem(extensionItem)
    
    // Prepare the URL Request
    let request = urlRequestWithExtensionItem(extensionItem, text: "hello")
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    extensionContext.completeRequestReturningItems(nil, completionHandler: nil)
  }
  
  override func configurationItems() -> AnyObject[]! {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return NSArray()
  }
  
  
  func urlRequestWithExtensionItem(extensionItem: NSExtensionItem, text: String) -> NSURLRequest? {
    let url = NSURL.URLWithString("http://requestb.in/15tnugc1")
    let request = NSMutableURLRequest(URL: url)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.HTTPMethod = "POST"
    return nil
  }
  
  func pictureDetailsFromExtensionItem(extensionItem: NSExtensionItem) -> Dictionary<String, String> {
    
    for attachment in extensionItem.attachments as NSItemProvider[] {
      if(attachment.hasItemConformingToTypeIdentifier(kUTTypeImage)) {
        attachment.loadItemForTypeIdentifier(kUTTypeImage, options: nil,
          completionHandler: {
            (image: NSSecureCoding!, error: NSError!) in
            let castedImage = image as UIImage
            println(castedImage)
          })
      }
    }
    return ["picture": "hi"]
  }
  
}
