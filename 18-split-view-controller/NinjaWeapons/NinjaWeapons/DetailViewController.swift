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

class DetailViewController: UIViewController {

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var partOfSpeechLabel: UILabel!
  @IBOutlet weak var furtherDetailLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var weaponImageView: UIImageView!
  
  var weapon: Weapon? {
    didSet {
      // Update the view.
      if isViewLoaded() {
        self.configureView()
      }
    }
  }
  
  func configureView() {
    // Update the user interface for the detail item.
    if let weapon = self.weapon {
      self.nameLabel.text = weapon.name
      self.partOfSpeechLabel.text = weapon.partOfSpeech
      self.furtherDetailLabel.text = weapon.alternative
      self.descriptionLabel.text = weapon.detail
      self.weaponImageView.image = weapon.image
      self.title = weapon.name
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.configureView()
  }
  
}

