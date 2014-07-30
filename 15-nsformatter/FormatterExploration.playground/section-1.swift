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
let now = NSDate()
let longTimeAgo = NSDate(timeIntervalSince1970: 0.0)
dateComponentsFormatter.unitsStyle = .Short
dateComponentsFormatter.stringFromDate(longTimeAgo, toDate: now)

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


