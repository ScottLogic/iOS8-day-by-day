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

import Security
import Foundation

protocol SecureStore {
  var secret: String? { get set }
}


class KeyChainStore: SecureStore {
  var serviceIdentifier = "TouchyFeelySecureStore"
  var accountName = "TouchyFeelyAccount"
  
  // MARK:- SecureStore protocol
  var secret: String? {
    get {
      return load()
    }
    set {
      if let newValue = newValue {
        save(newValue)
      } else {
        delete()
      }
    }
  }
  
  // MARK:- Utility methods
  private func save(token: String) {
    if let data = token.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
      
      // Rather than update, just delete and continue
      delete()
      
      // Create the appropriate access controls
      let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, .UserPresence, nil)
      
      let keyChainQuery = [
        kSecClass             : kSecClassGenericPassword,
        kSecAttrService       : serviceIdentifier,
        kSecAttrAccount       : accountName,
        kSecValueData         : data,
        kSecAttrAccessControl : accessControl.takeUnretainedValue()
      ]
      
      SecItemAdd(keyChainQuery, nil)
    }
  }
  
  private func load() -> String? {
    let keyChainQuery = [
      kSecClass              : kSecClassGenericPassword,
      kSecAttrService        : serviceIdentifier,
      kSecAttrAccount        : accountName,
      kSecReturnData         : true,
      kSecMatchLimit         : kSecMatchLimitOne,
      kSecUseOperationPrompt : "Authenticate to retrieve your secret!"
    ]
    
    var extractedData: Unmanaged<AnyObject>? = nil
    
    let status = SecItemCopyMatching(keyChainQuery, &extractedData)
    
    let opaque = extractedData?.toOpaque()
    var contentsOfKeychain: String?
    
    if let opaque = opaque {
      let retrievedData = Unmanaged<NSData>.fromOpaque(opaque).takeUnretainedValue()
      // Convert the data retrieved from the keychain into a string
      contentsOfKeychain = NSString(data: retrievedData, encoding: NSUTF8StringEncoding)
    } else {
      println("Nothing was retrieved from the keychain. Status code \(status)")
    }
    
    return contentsOfKeychain
  }
  
  private func delete() {
    // Instantiate a new default keychain query
    let keyChainQuery = [
      kSecClass       : kSecClassGenericPassword,
      kSecAttrService : serviceIdentifier,
      kSecAttrAccount : accountName
    ]
    
    SecItemDelete(keyChainQuery)
  }

}


