//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Sam Davies on 13/06/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext.completeRequestReturningItems(nil, completionHandler: nil)
    }

    override func configurationItems() -> AnyObject[]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return NSArray()
    }

}
