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

class TraitOverrideViewController: UIViewController, UISplitViewControllerDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    performTraitCollectionOverrideForSize(view.bounds.size)
    configureSplitVC()
  }
  
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    performTraitCollectionOverrideForSize(size)
  }
  
  private func performTraitCollectionOverrideForSize(size: CGSize) {
    var overrideTraitCollection: UITraitCollection? = nil
    if size.width > 320 {
      overrideTraitCollection = UITraitCollection(horizontalSizeClass: .Regular)
    }
    for vc in self.childViewControllers as [UIViewController] {
      setOverrideTraitCollection(overrideTraitCollection, forChildViewController: vc)
    }
  }
  
  private func configureSplitVC() {
    // Set up split view delegate
    let splitVC = self.childViewControllers[0] as UISplitViewController
    splitVC.delegate = self
    splitVC.preferredPrimaryColumnWidthFraction = 0.3
    let navVC = splitVC.childViewControllers.last as UINavigationController
    navVC.topViewController.navigationItem.leftBarButtonItem = splitVC.displayModeButtonItem()
  }
  
  
  // MARK: - Split view
  func splitViewController(splitViewController: UISplitViewController!, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {
    if let secondaryAsNavController = secondaryViewController as? UINavigationController {
      if let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController {
        if topAsDetailController.weapon == nil {
          // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
          return true
        }
      }
    }
    return false
  }
}
