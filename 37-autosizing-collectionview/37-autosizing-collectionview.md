# iOS8 Day-by-Day :: Day 37 :: Autosizing Collection View Cells

This post is part of a daily series of posts introducing the most exciting new
parts of iOS8 for developers - [#iOS8DayByDay](https://twitter.com/search?q=%23iOS8DayByDay).
To see the posts you've missed check out the [index page](http://shinobicontrols.com/iOS8DayByDay),
but have a read through the rest of this post first!

---

## Introduction

Way back on [day 5](http://www.shinobicontrols.com/blog/posts/2014/07/24/ios8-day-by-day-day-5-auto-sizing-table-view-cells/)
of this series, we took a look at the new functionality within table views that
allows cells to define their own height - using the power of auto layout. Well,
imagine a world where you could extend that same principle to collection views.
How cool would that be?

Well, in iOS8, you can! This functionality is built in to the flow layout, and
is easy to access when building your own layouts. In today's brief post you'll
discover how to use auto-sizing cells within a flow layout, and a little bit
about the underlying implementation. The sample app is available in the
iO8 Day-by-Day repo on github at
[github.com/ShinobiControls/iOS8-day-by-day](https://github.com/ShinobiControls/iOS8-day-by-day).


## Enabling Sizing in a Flow Layout

When using a `UICollectionViewFlowLayout`, you hardly need to to anything in
order to enable cell auto-sizing. The key thing, as in autosizing
`UITableViewCell`s, is to ensure that the size is completely defined using auto
layout constraints.

For example, in this custom cell, the label has constraints that link it to
every side of the cell:

![Cell Constraints](assets/cell_constraints.png)
![Cell Constraints](assets/cell_constraints2.png)

The other thing that you need to do to enable autosizing is specify an estimated
item size on the flow layout. This is new to iOS8 and plays a similar role to
its counterpart in `UITableView`.

To size cells in the past you had two options; one was to set the `itemSize`
property on `UICollectionViewFlowLayout` - applying the same size to every cell
within the collection view. For more fine-grained control on the cell sizes you
could implement the `collectionView(_, layout:, sizeForItemAtIndexPath:)` method
on `UICollectionViewDelegateFlowLayout`, however the responsibility for
calculating the size for each item is down to you - rather than the layout
engine built into UIKit. 

The `estimatedItemSize` property has a default of `CGSizeZero`, but setting it
to a non-zero size will enable the auto-sizing of cells.

The following code inside a `UICollectionViewController` subclass will enable
auto-sizing for it's flow layout.

    override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      if let cvl = collectionViewLayout as? UICollectionViewFlowLayout {
        cvl.estimatedItemSize = CGSize(width: 150, height: 75)
      }
    }

Note that since the name of this property includes _estimated_, you don't have
to be hugely accurate in the value you specify. In fact, the cells will only be
laid out and sized as they are about to arrive on screen. The estimated value is
used to size the scroll bars appropriately.

Enabling this line will take a layout that looked like this:

![Non-Autosizing](assets/default_layout.png)

and change its appearance to match this:

![Autosized](assets/autosized.png)

## Autosizing via Interface Builder

It seems a shame to have to drop to code to set the estimated size - all other
sizing properties associated with a flow layout can be configured within 
Interface Builder:

![Sizing in IB](assets/sizes.png)

However, you'll notice that there is nowhere obvious to configure the
`estimatedItemSize` property. Hopefully in future updates to Xcode this issue 
will be addressed, but until that point, it is is still possible to set the
value via the __User Defined Runtime Attributes__ panel inside the
__Identity Inspector__ for the `UICollectionViewFlowLayout`.

![Setting Estimated Size](assets/set_size_in_ib.png)

This panel allows you to set properties on objects via key-value coding - which
is essentially what the specialized panels in IB do anyway.


## Mechanics of Autosizing


## Conclusion

