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

import UIKit
import Social
import MobileCoreServices
import CoreGraphics


class ShareViewController: SLComposeServiceViewController {
  
  // The URL we're uploading to.
  // NOTE: This almost certainly _won't_ work for you. Create your own request bin
  //       at http://requestb.in/ and substitute that URL here.
  let sc_uploadURL = "http://requestb.in/ykc1ipyk"
  let sc_maxCharactersAllowed = 25
  
  var attachedImage: UIImage?
  
  
  override func isContentValid() -> Bool {
    // Do validation of contentText and/or NSExtensionContext attachments here
    if let currentMessage = contentText {
      let currentMessageLength = countElements(currentMessage)
      charactersRemaining = sc_maxCharactersAllowed - currentMessageLength
      
      if Int(charactersRemaining) < 0 {
        return false
      }
    }
    
    return true
  }
  
  override func presentationAnimationDidFinish() {
    // Only interested in the first item
    let extensionItem = extensionContext.inputItems[0] as NSExtensionItem
    // Extract an image (if one exists)
    imageFromExtensionItem(extensionItem) {
      image in
      if image != nil {
        dispatch_async(dispatch_get_main_queue()) {
          self.attachedImage = image
        }
      }
    }
  }
  
  override func didSelectPost() {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    let configName = "com.shinobicontrols.ShareAlike.BackgroundSessionConfig"
    let sessionConfig = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(configName)
    // Extensions aren't allowed their own cache disk space. Need to share with application
    sessionConfig.sharedContainerIdentifier = "group.ShareAlike"
    let session = NSURLSession(configuration: sessionConfig)
    
    // Prepare the URL Request
    let request = urlRequestWithImage(attachedImage, text: contentText)
    
    // Create the task, and kick it off
    let task = session.dataTaskWithRequest(request)
    
    if task != nil {
      task.resume()
    } else {
      println("The task is nil - you probably need to configure your share group")
    }
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    extensionContext.completeRequestReturningItems(nil, completionHandler: nil)
  }
  
  override func configurationItems() -> [AnyObject]! {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return NSArray()
  }
  
  
  func urlRequestWithImage(image: UIImage?, text: String) -> NSURLRequest? {
    let url = NSURL.URLWithString(sc_uploadURL)
    let request = NSMutableURLRequest(URL: url)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.HTTPMethod = "POST"
    
    var jsonObject = NSMutableDictionary()
    jsonObject["text"] = text
    if let image = image {
      jsonObject["image_details"] = extractDetailsFromImage(image)
    }
    
    // Create the JSON payload
    var jsonError: NSError?
    let jsonData = NSJSONSerialization.dataWithJSONObject(jsonObject, options: nil, error: &jsonError)
    if jsonData {
      request.HTTPBody = jsonData
    } else {
      if let error = jsonError {
        println("JSON Error: \(error.localizedDescription)")
      }
    }
    
    return request
  }
  
  func extractDetailsFromImage(image: UIImage) -> NSDictionary {
    var resultDict = NSMutableDictionary()
    resultDict["height"] = image.size.height
    resultDict["width"] = image.size.width
    resultDict["orientation"] = image.imageOrientation.toRaw()
    resultDict["scale"] = image.scale
    resultDict["description"] = image.description
    return resultDict.copy() as NSDictionary
  }
  
  func imageFromExtensionItem(extensionItem: NSExtensionItem, callback: (image: UIImage?)->Void) {
    
    for attachment in extensionItem.attachments as [NSItemProvider] {
      if(attachment.hasItemConformingToTypeIdentifier(kUTTypeImage as NSString)) {
        // Marshal on to a background thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, UInt(0))) {
          attachment.loadItemForTypeIdentifier(kUTTypeImage as NSString, options: nil) {
            (imageProvider, error) -> Void in
            var image: UIImage? = nil
            if let e = error {
              println("Item loading error: \(e.localizedDescription)")
            }
            image = imageProvider as? UIImage
            dispatch_async(dispatch_get_main_queue()) {
              callback(image: image)
            }
          }
        }
      }
    }
  }
  
}
