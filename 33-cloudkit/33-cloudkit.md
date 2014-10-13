# iOS8 Day-by-Day :: Day 33 :: CloudKit

This post is part of a daily series of posts introducing the most exciting new
parts of iOS8 for developers - [#iOS8DayByDay](https://twitter.com/search?q=%23iOS8DayByDay).
To see the posts you've missed check out the [index page](http://shinobicontrols.com/iOS8DayByDay),
but have a read through the rest of this post first!

---

## Introduction

Apple introduced iCloud to the world a couple of years ago, and since then has
been introducing new ways for developers to utilize it. First was iCloud
CoreData, which is meant to be a completely seamless way of persisting and
syncing a object graph across devices. This suffered from all kinds of issues,
and iOS8 introduces something which pretends to be much less in the form of
CloudKit.

CloudKit offers very little magic in terms of data-syncing, and has no elements
of local persistence. It is simply a remote database - a transport mechanism for
storing data remotely. Having said that, you do get a huge amount of
functionality from the API - including user management, huge storage and
bandwidth capacities, security and privacy.

Today's article is going to take a look at some of the features of CloudKit in
reasonable detail. The framework is really big, so not every feature will be
covered. There is a sample app to accompany the chapter - called __CloudNotes__.
This is a simple note taking app which uses CloudKit as a persistence layer.
Although this app demonstrates CloudKit fairly well, it should not be taken as
'best practice' for creating a data-driven app in this way. For example, there
is no facility for offline resilience. You can grab the source code of the app
from the repo on the ShinobiControls github at
[github.com/ShinobiControls/iOS8-day-by-day](https://github.com/ShinobiControls/iOS8-day-by-day).


## High-level CloudKit Concepts

- Container
- 2 databases public/private
- record zones
- records

## Creating Records

- Errors
- Main thread

## Querying For Records

- Alternative API

## Modifying Records

- Update/Delete
- Record ID

## CloudKit Dashboard

- Overview
- Can see structure
- 

## Summary of other Features

- __Change Notifications__ Subscriptions 
- __Blob fields__ CKAsset. Single record.
- __Transactions__ Atomic commits
- __Cascading Deletes__
- __Save Rules__
- __User lookups__
- __Production__

## Conclusion

