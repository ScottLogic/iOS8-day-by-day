# iOS8 Day-by-Day :: Day 31 :: Using Touch ID to Secure the Keychain

This post is part of a daily series of posts introducing the most exciting new
parts of iOS8 for developers - [#iOS8DayByDay](https://twitter.com/search?q=%23iOS8DayByDay).
To see the posts you've missed check out the [index page](http://shinobicontrols.com/iOS8DayByDay),
but have a read through the rest of this post first!

---

## Introduction

The iPhone 5s introduced the world to Touch ID - the ability to authenticate
with your device using just a finger print. In iOS7 use of this was limited to
unlocking the device, and purchases against your Apple ID. Developers were
desperate to get hold of an API to allow them to use this secure and convenient
method of authentication in their own apps. In iOS 8 this is now possible.

There are two classes of problem that you can solve using Touch ID in iOS8 -
authentication to access content of the Keychain, and confirming user presence
for your own app's usage. Today's article takes a look at how to use Touch ID in
tandem with the Keychain. If you want to know more about using Touch ID to
perform user authentication then take a look at LocalAuthentication in the
documentation.

The sample app which accompanies today's post is a very simple app which uses
the Keychain to save a secret and requires Touch ID authentication in order to
retrieve it. The code is available on the ShinobiControls github at
[github.com/ShinobiControls/iOS8-day-by-day](https://github.com/ShinobiControls/iOS8-day-by-day).


## Secure Enclave



## Access Control Lists

## Conclusion

