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

Before jumping in to look at some code, there are some architectural concepts
associated with CloudKit that you should get your head around.

### Authentication

Since CloudKit is build on iCloud, there isn't actually any authentication to
worry about - provided a user is logged into iCloud on the device, and they
permit your app to use iCloud then you're done! Your user would then be set up
with appropriate iCloud containers, and databases.

The developer doesn't get access to a list of users - which is great for
privacy. However, it does raise an interesting issue of discovery; loads of apps
expect the user to interact with their friends - which would be very difficult
if there's no way of discovering other users.

This is built in to CloudKit - a user can specify on a per-app basis whether
they want to allow users of that app to search for them by email address. As a
developer you can either implement this an individual search, or a full address
book search.

A user can opt-in or out of allowing an app to use the email address lookup
functionality, or indeed using iCloud altogether in the Settings app under
__iCloud Drive__.


### Containers

In the same way that the local storage available to your device is accessible
through a container, so too is your CloudKit allocation. This is the top-level
object in the world of CloudKit, and by default each app has its own,
independent container. It is possible that two apps signed by the same developer
share the same container - permitting sharing between iOS and OSX, as well as
across multiple apps on the same platform.

### Databases

The next level down the CloudKit tree is the databases that reside inside the
container. From the perspective of the app, each container has exactly two
databases: one _public_ and one _private_. The public database is shared between
_all_ users of this container - everybody can access the data, and by default
everybody can write to it.

The private database is, as you might expect, completely private to the current
user. This means that only the logged-in user has access to this data - they
can't choose to share part of it, nor can the developer take a look at a user's
private database. This is an extremely powerful feature - offering top-notch
privacy straight out of the box.

The API is very clear about which database you are interacting with - all
operations are performed on a database, and you use either the
`privateCloudDatabase` or `publicCloudDatabase` properties on your `CKContainer`
container object.

### Record Zones

Unlike in traditional relational databases, you can pop your records straight
into a database. You don't have to create a schema and associated tables - you
are free to implicitly build your schema as you go.

However, there is one more level between a database and records, and that is the
concept of a record zone. These just represent a collection of records -
allowing you to partition your data appropriately. Every database is created
with a default zone, but you are free to create your own custom zones as and
when you wish.

Zones offer some additional functionality to record partitioning, namely:

- __Per-zone Notifications__ Notifications are built into CloudKit - translating
into push notifications whenever something changes (see later). You can set up a
subscription to get notifications whenever something within a zone changes.
- __Atomic Commits__ This is essentially transactions - ensuring that all
records within a specified operation either complete or don't change at all.
This is crucial to ensuring the integrity of your data.
- __Delta Changes__ When an app arrives back on the network after being away it
can send a 'last-known-change' token upto iCloud, and it will then be sent all
the changes since that point, and a new token. This is invaluable for ensuring
that your local persistence store stays in sync with that on iCloud.

It is worth noting that records cannot change zones - instead they would have to
be recreated in a different zone, and that it's also not possible to have a
relationship between records in different zones.


### Records

As in many datastores, the lowest level of object in CloudKit is that of the
record. This is represented by the `CKRecord` class, and forms the basis of
every object type you want to store.

It is key-value coding compliant, and doesn't require you to specify the fields
up-front (much like `NSDictionary`). The field names should be strings, and the
values can be any of the following:

- `NSString`
- `NSNumber`
- `NSData`
- `NSDate`
- `CLLocation`
- `CKReference` - a reference to another `CKRecord`
- `CKAsset` - a binary blob of data uploaded to iCloud
- Arrays of the above

Records are created within a zone, and have a specified type - represented by a
string. All objects of the same type will share the same set of attributes -
much in the same way as you're used to in relational databases.

Records all have unique IDs, represented by the `CKRecordID` class, which
combines a zone ID with a record name. You can specify the record name
part of this ID when you create a record using the constructor that
takes a name. This is useful if you already have a unique ID for your object,
and don't want to manage two separate IDs. If you don't provide a record name,
one will be randomly generated for you.


### Subscriptions

Subscriptions allow you to ask iCloud to notify you of changes to the database
as they occur. You've already seen a mention of record zone subscriptions, which
will notify you when anything changes within a zone. It's also possible to
create query subscriptions - where you specify a query (via a predicate), and
the request that your app be notified if the results to the query should change.

Subscription notifications are delivered as push messages via APNS. There are
some caveats around their use - namely once a notification has been received,
it's important that you check for changes (since push notifications get
superseded).

Subscriptions offer a great alternative to polling iCloud to wait for changes.
This results in reduced power consumption - the holy grail of app optimization
requirements.


## Enabling CloudKit

CloudKit needs to be enabled on a per-app basis, and associated with a
particular developer ID. This involves adding the appropriate entitlements to
your app ID, and linking against the CloudKit framework.

Xcode has you covered in this area - via the __Capabilities__ tab of you project
settings file:

![iCloud Entitlements](assets/icloud_entitlements.png)

Flicking the switch will enable iCloud for your app:

![Enable iCloud](assets/enable_icloud.png)

Note that the default settings just enable the iCloud Key-Value store, and that
you need to check the __CloudKit__ checkbox to link against the correct
framework and configure the entitlements appropriately:

![Enable CloudKit](assets/enable_cloudkit.png)

At this point you can create custom containers, should you wish to, or you can
stick with the default container created for you.

Notice that there is also a button labeled __CloudKit Dashboard__ that will sned
your browser to the web dashboard associated with this container. You can read
more about the dashboard later in this article.

Now that you've enabled CloudKit, you can go ahead and start creating pushing
some data into it.

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

