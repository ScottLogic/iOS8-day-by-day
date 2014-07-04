# iOS8 Day-by-Day :: Day 9 :: Designated Initialisers

This post is part of a daily series of posts introducing the most exciting new
parts of iOS8 for developers - [#iOS8DayByDay](https://twitter.com/search?q=%23iOS8DayByDay).
To see the posts you've missed check out the introduction page,
but have a read through the rest of this post first!

---

## Introduction

The concept of designated initialisers is not new to the Cocoa world - they have
exist in objective-C, but somewhat informally. Swift formalises class initialisation,
both in terms of what the different initialisation methods should do, and the
order in which things should be done.

In order to ease interoperability with objective-C, there is also a little more
formalisation there too.

In this post you'll learn a bit about how initialisation works in Swift, with
an explanation of what designated initialisers are, and how they related to
convenience initialisers.

The accompanying code for this project is part of an Xcode playground - and is
available in the repo on github at
[github.com/ShinobiControls/iOS8-day-by-day](https://github.com/ShinobiControls/iOS8-day-by-day).
You should be able to just open it up and see the live-run results.

## Creating objects

Initialisers are used to instantiate an instance of a class or a struct. There are
two types of initialiser:

- __Designated__ This is responsible for preparing all the properties, and calling
the superclass' initialiser, allowing it to do the same.
- __Convenience__ Don't have to directly prepare and instance state, but must
call a designated initialiser. Cannot call an initialiser of the superclass.

For example:

    class Person {
      var name: String
      var age: Int?
      var consideredDangerous = false

      init(name: String, age: Int?) {
        self.name = name
        self.age = age
      }
    }

This is a class which has 3 properties. `init(name:,age:)` is a designated
initialiser, and therefore it is responsible for ensuring that all properties have
been correctly initialised. In the example above that actually only means that it
must set a value for the `name` property. This is because optionals will be set
to `nil` by default, and `consideredDangerous` is set inline.

Since the age is optional, we might want to offer another initialiser which just
accepts a name. One option would be to make another designated initialiser:


    init(name: String) {
      self.name = name
    }

This is perfectly acceptable, but it is actually repeating the same code as in
the previous designated initialiser. Should you decide to store uppercase names,
then you'd have to change both initialisers. This is where the concept of initialiser
chaining comes in - which is the pattern established with convenience initialisers.

### Convenience Initialisers

Convenience initialisers are denoted by the use of the `convenience` keyword, and
they __must__ call a designated initialiser:

    convenience init(name: String) {
      self.init(name: name, age: nil)
    }

This method now has the desired behaviour - it only requires a name, and delegates
the actual initialisation to a designated initialiser. Convenience initialisers
__cannot__ call the super class, but __must__ call a designated initialiser in the
same class.


### Subclassing




## Usage in Swift

## Usage in objective-C

## Conclusion
