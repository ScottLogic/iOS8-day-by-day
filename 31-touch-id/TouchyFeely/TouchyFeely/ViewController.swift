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

class ViewController: UIViewController {

  @IBOutlet weak var secretInputTextField: UITextField!
  @IBOutlet weak var secretRetrievalLabel: UILabel!
  @IBOutlet weak var commitButton: UIButton!
  @IBOutlet weak var retrieveButton: UIButton!
  
  let secureStore = KeyChainStore()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    secretRetrievalLabel.alpha = 0.0
  }

  
  // MARK:- IBActions
  @IBAction func commitSecret(sender: AnyObject) {
    secretInputTextField.resignFirstResponder()
    // Get the string to save
    let secretToSave = secretInputTextField.text
    // Save it
    secureStore.secret = secretToSave
    // Clear the input
    secretInputTextField.text = ""
    secretRetrievalLabel.text = "<placeholder>"
  }

  @IBAction func retrieveSecret(sender: AnyObject) {
    secretInputTextField.resignFirstResponder()
    let secret = secureStore.secret
    secretRetrievalLabel.text = secret
    secretRetrievalLabel.alpha = 1.0
    let fadeOutTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 1.0))
    dispatch_after(fadeOutTime, dispatch_get_main_queue()) {
      UIView.animateWithDuration(0.5, animations: {
          self.secretRetrievalLabel.alpha = 0.0
        }, completion: {
          _ in
          self.secretRetrievalLabel.text = "<placeholder>"
      })
    }
  }
  
  
}

