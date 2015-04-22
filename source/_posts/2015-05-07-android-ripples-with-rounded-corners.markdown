---
layout: post
title: "Android Ripples with Rounded Corners"
date: 2015-05-07 22:55:36 -0400
comments: true
categories: [Android, Development, Code]
description: "Android Ripples with Rounded Corners"
keywords: "Android, Development"
---

So recently I was trying to add a ripple to a view that had rounded corners. Simple enough right? Let's just say I have a FrameLayout with the background similar to this one:

```
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="rectangle">
    <solid android:color="@android:color/transparent"/>
    <corners android:radius="15dp" />
    <stroke
        android:width="1px"
        android:color="#000000" />
</shape>
```

It's not quite as simple as setting the foreground to `?attr/selectableItemBackground`, or else you'll see the ripple surpasses the corners (which doesn't look _so_ bad when your border radius is small, but this would look terrible with a circlular view):

{% img center /images/2015/05/07/before.gif 600 600 Rounded Corner Fail! %}

The solution for this lies in the special mask layer of the [RippleDrawable](https://developer.android.com/reference/android/graphics/drawable/RippleDrawable.html). You specify the mask layer via the `android:id` value set to `@android:id/mask`. For the example above, you can set the mask to the same size/shape as the view you're masking, and then the ripple will only show for that area. For something like our example above, you'd use something like this:

```
<?xml version="1.0" encoding="utf-8"?>
<ripple xmlns:android="http://schemas.android.com/apk/res/android"
    android:color="?android:attr/colorControlHighlight">
    <item android:id="@android:id/mask">
        <shape android:shape="rectangle">
            <solid android:color="#000000" />
            <corners android:radius="15dp" />
        </shape>
    </item>
    <item android:drawable="@drawable/rounded_corners" />
</ripple>
```

Now when you tap on the view, you'll see something like this:

{% img center /images/2015/05/07/after.gif 600 600 Rounded Corners! %}

*Huzzah!*

Another tip: if you don't set a click listener for a FrameLayout (like we used in this example), the pressed state will never be used!

