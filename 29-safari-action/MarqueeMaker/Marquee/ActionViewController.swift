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
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Get the item[s] we're handling from the extension context.
        
        // For example, look for an image and place it into an image view.
        // Replace this with something appropriate for the type[s] your extension supports.
        var imageFound = false
        for item: AnyObject in self.extensionContext!.inputItems {
            let inputItem = item as NSExtensionItem
            for provider: AnyObject in inputItem.attachments! {
                let itemProvider = provider as NSItemProvider
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeImage as NSString) {
                    // This is an image. We'll load it, then place it in our image view.
                    weak var weakImageView = self.imageView
                    itemProvider.loadItemForTypeIdentifier(kUTTypeImage as NSString, options: nil, completionHandler: { (image, error) in
                        if image != nil {
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                if let imageView = weakImageView {
                                    imageView.image = image as? UIImage
                                }
                            }
                        }
                    })
                    
                    imageFound = true
                    break
                }
            }
            
            if (imageFound) {
                // We only handle one image, so stop looking for more.
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequestReturningItems(self.extensionContext!.inputItems, completionHandler: nil)
    }

}
