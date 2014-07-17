# iOS8 Day-by-Day :: Day 1 :: Swift for Blaggers

This post is part of a daily series of posts introducing the most exciting new
parts of iOS8 for developers - [#iOS8DayByDay](https://twitter.com/search?q=%23iOS8DayByDay).
To see the posts you've missed check out the
[introduction page](http://www.shinobicontrols.com/ios8daybyday),
but have a read through the rest of this post first!

---

## Introduction

It won't have gone unnoticed that at WWDC this year, in addition to announcing
iOS8, they also introduced a new programming language in the form of Swift. This
is quite a different language from objective-C in that it is strongly-typed and
includes some features common to more modern languages.

In the interests of embracing anything and everything that's new and shiny, this
blog series will exclusively use Swift. There is a wealth of information out
there about how to learn Swift, and how to interact with the Cocoa libraries -
in fact you can't go wrong with starting out by reading through the official
books:

- [The Swift Programming Language](https://itunes.apple.com/us/book/the-swift-programming-language/id881256329?mt=11&ls=1)
- [Using Swift with Cocoa and Objective-C](https://itunes.apple.com/us/book/using-swift-cocoa-objective/id888894773?mt=11&ls=1)

You should also check out the official
[swift blog](https://developer.apple.com/swift/blog/), and some of the other
[resources](https://developer.apple.com/swift/resources/) made available by
Apple.

Since there is so much good info out there about how to use Swift, this post is
not going to attempt to cover any of that. Instead, it's going to run through
some of the important gotchas and potential pain points when using Swift for
the first time - especially when relating to the system frameworks.

If you have any questions or suggestions of other things to add to this post
then do let me know - I'll try to keep it up to date throughout the blog series.
Drop a comment below, or gimme a shout on twitter -
[@iwantmyrealname](https://twitter.com/iwantmyrealname).


## Initialisation

Swift formalises the concepts surround initialisation of objects somewhat -
including designated -vs- convenience initialisers, and sets a very specific
order of the operations to be called within the initialisation phases of an
object. In the coming weeks, there will be an article as part of this series
which will go into detail about how initialisation works in Swift, and how this
affects any objective-C that you write - so look out for this.

There is one other fairly major difference in initialisation between Swift and
objective-C, and that is return values and initialisation failure. In objective-C
an initialiser looks a lot like this:

    - (instancetype)init {
      self = [super init];
      if (self) {
        // Do some stuff
      }
      return self;
    }

Whereas in Swift:

    init {
      variableA = 10
      ...
      super.init()
    }

Notice that in objective-C the initialiser is responsible for 'creating' and then
returning `self`, but there is no `return` statement in the Swift equivalent.
This means that there is actually no way in which you can return a `nil` object,
which is a pattern commonly used to indicate an initialisation failure in objC.

This is apparently likely to change in an upcoming release of the language, but
for now the only workaround is to use class methods which return optional types:

    class MyClass {
      class func myFactoryMethod() -> MyClass? {
        ...
      }
    }

Interestingly, factory methods on objective-C APIs are converted into initialisers
in Swift, so this approach is not preferred. However, until language support
arrives, it's the only option for initialisers which have the potential to fail.

## Mutability



## Strong Typing and `AnyObject`


## Protocol Conformance


## Enums





## Conclusion
