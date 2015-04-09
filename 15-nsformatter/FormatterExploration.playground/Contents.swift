import UIKit

//MARK: NSDateComponentsFormatter
let dateComponentsFormatter = NSDateComponentsFormatter()
let components = NSDateComponents()
components.hour   = 2
components.minute = 45

let dcfStyles: [NSDateComponentsFormatterUnitsStyle] =
  [.Positional, .Abbreviated, .Short, .Full, .SpellOut]
for style in dcfStyles {
  dateComponentsFormatter.unitsStyle = style
  dateComponentsFormatter.stringFromDateComponents(components)
}

let calendar = NSCalendar.currentCalendar()
calendar.locale = NSLocale(localeIdentifier: "th-TH")
dateComponentsFormatter.calendar = calendar
dateComponentsFormatter.stringFromDateComponents(components)

dateComponentsFormatter.calendar = NSCalendar.currentCalendar()
let now = NSDate()
let longTimeAgo = NSDate(timeIntervalSince1970: 0.0)
dateComponentsFormatter.unitsStyle = .Short
dateComponentsFormatter.stringFromDate(longTimeAgo, toDate: now)

// Extra strings
dateComponentsFormatter.includesApproximationPhrase = true
dateComponentsFormatter.stringFromDateComponents(components)
dateComponentsFormatter.includesTimeRemainingPhrase = true
dateComponentsFormatter.stringFromDateComponents(components)



//MARK: NSDateIntervalFormatter 
let dateIntervalFormatter = NSDateIntervalFormatter()
let difStyles: [NSDateIntervalFormatterStyle] =
  [.NoStyle, .ShortStyle, .MediumStyle, .LongStyle, .FullStyle]
for style in difStyles {
  dateIntervalFormatter.dateStyle = style
  dateIntervalFormatter.timeStyle = style
  dateIntervalFormatter.stringFromDate(longTimeAgo, toDate: now)
}


//MARK: NSLengthFormatter
let lengthFormatter = NSLengthFormatter()
lengthFormatter.stringFromMeters(1.65)
let lfUnits: [NSLengthFormatterUnit] =
  [.Millimeter, .Centimeter, .Meter, .Kilometer, .Inch, .Foot, .Yard, .Mile]
for unit in lfUnits {
  lengthFormatter.stringFromValue(15.2, unit: unit)
  lengthFormatter.unitStringFromValue(10.3, unit: unit)
}
lengthFormatter.forPersonHeightUse = true
lengthFormatter.stringFromMeters(1.65)
let unitStyles: [NSFormattingUnitStyle] = [.Short, .Medium, .Long]
for style in unitStyles {
  lengthFormatter.unitStyle = style
  lengthFormatter.stringFromValue(1.65, unit: .Meter)
}


//MARK: NSMassFormatter
let massFormatter = NSMassFormatter()
massFormatter.stringFromKilograms(56.4)
let mfUnits: [NSMassFormatterUnit] =
  [.Gram, .Kilogram, .Ounce, .Pound, .Stone]
for unit in mfUnits {
  massFormatter.stringFromValue(165.2, unit: unit)
}
massFormatter.forPersonMassUse = true
massFormatter.stringFromKilograms(76.2)
for style in unitStyles {
  massFormatter.unitStyle = style
  massFormatter.stringFromValue(34.2, unit: .Kilogram)
}

//MARK: NSEnergyFormatter
let energyFormatter = NSEnergyFormatter()
energyFormatter.stringFromJoules(42.5)
let efUnits: [NSEnergyFormatterUnit] =
  [.Joule, .Kilojoule, .Calorie, .Kilocalorie]
for unit in efUnits {
  energyFormatter.stringFromValue(54.2, unit: unit)
}
energyFormatter.forFoodEnergyUse = true
energyFormatter.stringFromJoules(4200)
for style in unitStyles {
  energyFormatter.unitStyle = style
  energyFormatter.stringFromValue(5.6, unit: .Kilojoule)
}


for style in unitStyles {
  energyFormatter.unitStyle = style
  energyFormatter.forFoodEnergyUse = false
  energyFormatter.stringFromValue(6.75, unit: .Kilocalorie)
  energyFormatter.forFoodEnergyUse = true
  energyFormatter.stringFromValue(6.75, unit: .Kilocalorie)
}


