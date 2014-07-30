# iOS8 Day-by-Day :: Day 15 :: NSFormatter

This post is part of a daily series of posts introducing the most exciting new
parts of iOS8 for developers - [#iOS8DayByDay](https://twitter.com/search?q=%23iOS8DayByDay).
To see the posts you've missed check out the
[introduction page](http://www.shinobicontrols.com/ios8daybyday),
but have a read through the rest of this post first!

---

## Introduction

Many apps that we built represent data flow in some form or another. However,
since apps are primarily visual it's often important to display this data to the
user. This requires converting numbers, dates etc to strings which the user will
understand. This is more complicated than it might sound - since different
locales will have different formatting conventions, different names and even
different calendars.

Cocoa has traditionally been very strong in this area - with the `NSFormatter`
abstract class - and more specifically the `NSNumberFormatter` and
`NSDateFormatter` concrete implementations. You'll almost certainly have come
across them in your app development - e.g. converting an `NSDate` object to a
string for display in an `UILabel`.

iOS8 adds to this family of `NSFormatter` concrete implementations with some new
date/time formatters and some physical quantity formatters. This article will
take a quick tour of the new formatters, and how to use them.

The sample code which accompanies this post is in the form of a Xcode 6
playground, and is available in the iOS8 Day-by-Day git repo on the
ShinobiControls github at
[github.com/ShinobiControls/iOS8-day-by-day](https://github.com/ShinobiControls/
iOS8-day-by-day).


## Temporal Formatters

Joining the hugely popular `NSDateFormatter` are two new formatters -
`NSDateComponentsFormatter` and `NSDateIntervalFormatter`.

### NSDateComponentsFormatter

`NSDateFormatter` is useful for creating a string which represents a specific
point in time (e.g. "12th June 2010"), but it can't be used for specifying some
kind of temporal duration (e.g. "12 days 13 hours and 12 minutes"). These
durations are still very much in need of a formatter, since they need to be
carefully localized. Enter `NSDateComponentsFormatter`, which can create a
suitably localized string for an instance of `NSDateComponents`.

    let dateComponentsFormatter = NSDateComponentsFormatter()
    let components = NSDateComponents()
    components.hour   = 2
    components.minute = 45

`NSDateComponentsFormatter` has a `unitsStyle` property which can be any one of
`.Positional`, `.Abbreviated`, `.Short`, `.Full`, or `.SpellOut`:

The following snippet demos the different unit styles:

    let dcfStyles: [NSDateComponentsFormatterUnitsStyle] =
      [.Positional, .Abbreviated, .Short, .Full, .SpellOut]
    for style in dcfStyles {
      dateComponentsFormatter.unitsStyle = style
      dateComponentsFormatter.stringFromDateComponents(components)
    }

| Units Style    | Result                        |
|----------------|-------------------------------|
| `.Positional`  | 2:45                          |
| `.Abbreviated` | 2h 45m                        |
| `.Short`       | 2 hrs, 45 mins                |
| `.Full`        | 2 hours, 45 minutes           |
| `.SpellOut`    | two hours, forty-five minutes |

By default these string are localized to the default locale, but you can
override this by providing a specific `NSCalendar` instance:

    let calendar = NSCalendar.currentCalendar()
    calendar.locale = NSLocale(localeIdentifier: "th-TH")
    dateComponentsFormatter.calendar = calendar
    dateComponentsFormatter.stringFromDateComponents(components)
    // => สอง ชั่วโมง และ สี่​สิบ​ห้า นาที

You can also specify that "approximation" and "remaining" phrases be added to
the output string:

    dateComponentsFormatter.includesApproximationPhrase = true
    dateComponentsFormatter.stringFromDateComponents(components)
    // => About 2 hrs, 45 mins
    dateComponentsFormatter.includesTimeRemainingPhrase = true
    dateComponentsFormatter.stringFromDateComponents(components)
    // => About 2 hrs, 45 mins remaining


### NSDateIntervalFormatter

`NSDateComponentsFormatter` is really useful for creating duration strings, but
if you want to specify a specific time interval, then `NSDateIntervalFormatter`
is you friend. It takes two `NSDate` objects, and again has a selection of
different time and date styles, which can be set independently for the time and
the date:

    let dateIntervalFormatter = NSDateIntervalFormatter()
    let now = NSDate()
    let longTimeAgo = NSDate(timeIntervalSince1970: 0.0)
    let difStyles: [NSDateIntervalFormatterStyle] =
      [.NoStyle, .ShortStyle, .MediumStyle, .LongStyle, .FullStyle]
    for style in difStyles {
      dateIntervalFormatter.dateStyle = style
      dateIntervalFormatter.timeStyle = style
      dateIntervalFormatter.stringFromDate(longTimeAgo, toDate: now)
    }

| Style          | Result |
|----------------|--------|
| `.NoStyle`     |        |
| `.ShortStyle`  | 1/1/70, 1:00 AM - 7/30/14, 9:32 AM |
| `.MediumStyle` | Jan 1, 1970, 1:00:00 AM - Jul 30, 2014, 9:32:35 AM |
| `.LongStyle`   | January 1, 1970, 1:00:00 AM GMT+1 - July 30, 2014, 9:32:35 AM GMT+1 |
| `.FullStye`    | Thursday, January 1, 1970, 1:00:00 AM GMT+01:00 - Wednesday, July 30, 2014, 9:32:35 AM British Summer Time |


## Physical Quantity Formatters



### NSLengthFormatter


### NSMassFormatter


### NSEnergyFormatter


## Conclusion