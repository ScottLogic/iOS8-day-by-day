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

class LoadingOverlay: UIView {

  let loadingLabel = UILabel()
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  
  private func commonInit() {
    loadingLabel.text = "Loading..."
    self.addSubview(loadingLabel)
    loadingLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
    loadingLabel.textAlignment = .Center
    loadingLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 42.0)
    let vCons = NSLayoutConstraint(item: loadingLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0)
    let hCons = NSLayoutConstraint(item: loadingLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0)
    NSLayoutConstraint.activateConstraints([vCons, hCons])
    
    self.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
  }

}
