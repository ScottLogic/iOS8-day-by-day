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
[github.com/ShinobiControls/iOS8-day-by-day](https://github.com/ShinobiControls/iOS8-day-by-day).


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

A completely new addition to the `NSFormatter` family in iOS are the physical
quantity formatters, which have primarily been added in support of HealthKit.
They all contain the ability to format numbers with a selection of relevant
units.

### NSLengthFormatter

`NSLengthFormatter` is used to format numbers as lengths, and includes
localizable units such as metres, inches, yards and miles. The
`stringFromMeters()` method will convert from a value in meters to the unit
appropriate for the current locale, whereas the `stringFromValue()` method takes
a units value, allowing you to specify what the number represents, and should be
output:

    let lengthFormatter = NSLengthFormatter()
    lengthFormatter.stringFromMeters(1.65)
    // => 1.804 yd
    let lfUnits: [NSLengthFormatterUnit] =
      [.Millimeter, .Centimeter, .Meter, .Kilometer, .Inch, .Foot, .Yard, .Mile]
    for unit in lfUnits {
      lengthFormatter.stringFromValue(15.2, unit: unit)
      lengthFormatter.unitStringFromValue(10.3, unit: unit)
    }

`NSLengthFormatterUnit` allows you to specify which unit type should be used:

| Unit          | Result  |
|---------------|---------|
| `.Millimeter` | 15.2 mm |
| `.Centimeter` | 15.2 cm |
| `.Meter`      | 15.2 m  |
| `.Kilometer`  | 15.2 km |
| `.Inch`       | 15.2 in |
| `.Foot`       | 15.2 ft |
| `.Yard`       | 15.2 yd |
| `.Mile`       | 15.2 mi |

You can also specify unit styles as well, which allow you to control the length
of the units themselves:

    let unitStyles: [NSFormattingUnitStyle] = [.Short, .Medium, .Long]
    for style in unitStyles {
      lengthFormatter.unitStyle = style
      lengthFormatter.stringFromValue(1.65, unit: .Meter)
    }

| Style     | Result      |
|-----------|-------------|
| `.Short`  | 1.65m       |
| `.Medium` | 1.65 m      |
| `.Long`   | 1.65 meters |

In some locales, the units used for measuring a person's height are different
from those used to measure other lengths - e.g. human height is rarely measured
in yards. `NSLengthFormatter` has a boolean `forPesonHeightUse` property which
controls this behavior.

If you only require the units, as opposed to the number with the units then the
`unitsStringFromValue(,unit:)` method allows will do that for you. It respects
the current `unitStyle`, and uses the provided `value` to determine whether or
not the unit should be plural.

### NSMassFormatter

In many respects, the `NSMassFormatter` is very similar to the
`NSLengthFormatter`, but representing the physical quantity of mass instead of
distance. It too can convert from the standard unit (kilograms) to the unit used
in the appropriate locale, and also has a selection of units available for
manual use:

    let massFormatter = NSMassFormatter()
    massFormatter.stringFromKilograms(56.4)
    // => 124.08 lb
    let mfUnits: [NSMassFormatterUnit] =
      [.Gram, .Kilogram, .Ounce, .Pound, .Stone]
    for unit in mfUnits {
      massFormatter.stringFromValue(165.2, unit: unit)
    }

| Unit        | Result   |
|-------------|----------|
| `.Gram`     | 165.2 g  |
| `.Kilogram` | 165.2 kg |
| `.Ounce`    | 165.2 oz |
| `.Pound`    | 165.2 lb |
| `.Stone`    | 165.2 st |

And again, you can specify the style of the units:

    massFormatter.stringFromKilograms(76.2)
    for style in unitStyles {
      massFormatter.unitStyle = style
      massFormatter.stringFromValue(34.2, unit: .Kilogram)
    }

| Style     | Result         |
|-----------|----------------|
| `.Short`  | 34.2kg         |
| `.Medium` | 34.2 kg        |
| `.Long`   | 34.2 kilograms |

Again, some locales tend to use different (some may say strange) units to
measure the mass of a human, and therefore there is a `forPersonMassUse`
property which will switch the formatter into 'human' mode.

### NSEnergyFormatter

The final new formatter is for formatting energy, and its existence is driven
by the requirement to measure the energy content of food in HealthKit. It shares
many of the same features of the previous two physical quantity formatters.

The `stringFromJoules()` method will convert to the unit it thinks is most
appropriate for the locale, but once again you can specify units with
`stringFromValue(,unit:)`:

    let energyFormatter = NSEnergyFormatter()
    energyFormatter.stringFromJoules(42.5)
    // => 10.158 cal
    let efUnits: [NSEnergyFormatterUnit] =
      [.Joule, .Kilojoule, .Calorie, .Kilocalorie]
    for unit in efUnits {
      energyFormatter.stringFromValue(54.2, unit: unit)
    }

| Unit           | Result    |
|----------------|-----------|
| `.Joule`       | 54.2 J    |
| `.Kilojoule`   | 54.2 kJ   |
| `.Calorie`     | 54.2 cal  |
| `.Kilocalorie` | 54.2 kcal |

In the same way as before, you can specify a selection of unit styles:

    for style in unitStyles {
      energyFormatter.unitStyle = style
      energyFormatter.stringFromValue(5.6, unit: .Kilojoule)
    }

| Style     | Result         |
|-----------|----------------|
| `.Short`  | 5.6kJ          |
| `.Medium` | 5.6 kJ         |
| `.Long`   | 5.6 kilojoules |

For some completely unimaginable reason, when referring to the energy content of
food, some locales tend to invent a new unit, helpfully called "calories", which
is identical to a traditional "kilocalorie". Luckily, before I go off on a rant,
`NSEnergyFormatter` has your back - with the `forFoodEnergyUse` property:

    energyFormatter.forFoodEnergyUse = true
    energyFormatter.stringFromJoules(4200)
    // => 1.004 Cal


## Conclusion

Formatting values is hard enough in the locale you use every day, but attempting
to get it right across all locales is near-enough impossible. In the past
numbers and dates have been possible through the existing `NSFormatter`
subclasses, but iOS8 adds some great new formatters to ease this pain.

This new functionality isn't something that you're likely to be able to rush out
and use immediately to implement some cool new feature, but it's one of those
things that is incredibly useful when you need it. The important part is to
remember that these formatters exist, so that next time you are creating an app
which needs to represent a distance, or a duration, you know that you can have
localization for free.

The code for this post is all available in a playground which you can get from
the ShinobiControls github at
[github.com/ShinobiControls/ios8-day-by-day]. If you have any questions, or
fancy a new person to follow (I'd very much like that - it makes me feel loved)
then I'm [@iwantmyrealname](https://twitter.com/iwantmyrealname) on Twitter.

sam