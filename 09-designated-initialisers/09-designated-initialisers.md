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

When you create a subclass then in addition to the aforementioned rules associated
with designated initialisers, you are also required to call a designated
initialiser of the superclass.

Look at the following example - a ninja is clearly a person, but they have a
collection of weapons, defined by the accompanying enum:

    class Ninja: Person {
      var weapons: Weapon[]?
    }

    enum Weapon {
      case Katana, Tsuba, Shuriken, Kusarigama, Fukiya
    }

The `Ninja` class definition doesn't currently have an initialiser, and since
the only additional property is an optional (and thus defaults to nil) it isn't
a requirement to have one. However, it'd be nice to add one which allows setting
the weapons array at initialisation time:

    init(name: String, age: Int?, weapons: Weapon[]?) {
      self.weapons = weapons

      super.init(name: name, age: age)

      self.consideredDangerous = true
    }

This demonstrates the rules of how a designated initialiser must be formed in
Swift:

1. Any properties on the subclass must be initialised correctly. Here it's not
strictly necessary since `weapons` is an optional type.
2. Once the current object's properties are all initialised, there __must__ be
a call to a designated initialiser on the superclass.
3. You can then update any properties inherited from the superclass.

This order is very important, and changing it will result in compiler errors. Note
that the order is different to the ordering used in subclass initialisers in
objective-C, where the call to the superclass is the first instruction.

You can add convenience initialisers to subclasses as well, but they must call
a designated initialiser of the same class. They __cannnot__ call an initialiser
of a superclass:

    convenience init(name: String) {
      self.init(name: name, age: nil, weapons: nil)
    }

This results in you being able to create ninjas in 2 ways:

    let tina = Ninja(name: "tina", age: 23, weapons: [.Fukiya, .Tsuba])
    let trevor = Ninja(name: "trevor")


## Usage in objective-C

Objective-C has the notion of designated initialisers - but in an informal context.
In order to enable full interoperability between objective-C and Swift, there is
a macro with which you can annotate your objective-C initialisers:
`NS_DESIGNATED_INITIALIZER`:

    - (instancetype)init NS_DESIGNATED_INITIALIZER;

By using this, then all other initialisers in your class will be interpreted as
being convenience initialisers. The same rules apply with objective-C initialisers
as their Swift counterparts.

## Conclusion

The designated initialiser pattern has existed in the Cocoa world for a long time,
but Swift formalises it somewhat. You'll need to fully understand it and what
is required of you as a developer in order to create your own classes and subclasses
in Swift.

It's also definitely worth adopting the new macro in any new objective-C that you
write, particularly if you want it to be interoperable with Swift code.

The code which accompanies this post is in the form of an Xcode 6 playground -
and demonstrates how the different patterns work. It is part of the day-by-day
repo on the ShinobiControls github at
[github.com/ShinobiControls/iOS8-day-by-day](https://github.com/ShinobiControls/iOS8-day-by-day).
If you have any questions about this topic, then Apple's Swift book is very
thorough, or feel free to grab me on twitter - [@iwanymyrealname](https://twitter.com/iwanymyrealname)


sam
