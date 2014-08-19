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

struct Weapon {
  let name: String
  let partOfSpeech: String
  let alternative: String
  let detail: String
  let imageName: String
  
  var image: UIImage {
    return UIImage(named: imageName)
  }
  
  init(dictionary: [String:String]) {
    name = dictionary["name"]!
    partOfSpeech = dictionary["partOfSpeech"]!
    alternative = dictionary["alternative"]!
    detail = dictionary["detail"]!
    imageName = dictionary["image"]!
  }
}

class WeaponProvider {
  private(set) var weapons = [Weapon]()
  
  convenience init() {
    // Default name
    self.init(plistNamed: "WeaponCollection")
  }
  
  init(plistNamed: String) {
    self.weapons = self.loadWeaponsFromPListNamed(plistNamed)
  }
  
  private func loadWeaponsFromPListNamed(plistName: String) -> [Weapon] {
    let path = NSBundle.mainBundle().pathForResource(plistName, ofType: "plist")
    let rawArray = NSArray(contentsOfFile: path!)
    var weaponCollection = [Weapon]()
    for rawWeapon in rawArray as [[String:String]] {
      weaponCollection.append(Weapon(dictionary: rawWeapon))
    }
    return weaponCollection
  }
}


