---
layout: post
title: "Improving App Debugging with Flipper"
date: 2019-10-15 20:10:22 -0400
comments: true
categories: [Android]
description: "Improving App Debugging with Flipper"
keywords: "Android"
---

Some time last year, Facebook released a new mobile debugging tool, named [Flipper](https://fbflipper.com/). It's essentially the successor to the widely popular [Stetho](http://facebook.github.io/stetho/), although after talking to many developers, it seems like this newer tool is relatively unknown. 

Like Stetho, Flipper has many features - including a layout inspector, a database inspector and a network inspector. Unlike Stetho though, Flipper has a very extensible API which allows for tons of customization. Over the next few articles, we're going to take a look at these APIs, and demonstrate how we can leverage them to help us debug various parts of our app. This post will focus on getting set up with Flipper, as well as building our first extension to the tool. 

## Getting Started

## Quick edits

The first thing you can do in the Layout Inspector that's really cool is actually _edit_ properties! Pretty mind blowing to make tweaks in the inspector and watch the views change in realtime. It's really handy for experimenting with changing padding, and text colors. It doesn't actually edit any of your xml files, but this allows you to iterate quickly to make sure everything looks right.

Let's find a view we want to update: 

{% img center /images/2019/10/15/step_0.png 600 600 Select a View %}

{% img center /images/2019/10/15/step_1.png 800 800 Select a View %}

We can click on the the color swatch to open a color picker:

{% img center /images/2019/10/15/step_2.png 800 800 Select a View %}

{% img center /images/2019/10/15/step_3.png 800 800 Select a View %}

And now when we look over at our device:

{% img center /images/2019/10/15/step_4.png 600 600 Select a View %}

Neat!

## Extending

Besides the real-time editing of our layout, the coolest thing that Flipper offers is its extensibility. Let's say for a moment that you have a custom view that has properties that aren't displayed out of the box. Flipper offers an API called `NodeDescriptor` that allows us to tell the inspector what properties are available to display. 

As an example, we notice that Activities in the inspector don't show their extras like Fragments do. Let's write a NodeDescriptor for Activities that will display the extras passed to the intent. The code will look something like this:

```
class PlaidActivityDescriptor : ActivityDescriptor() {
    override fun getData(node: Activity): MutableList<Named<FlipperObject>> {
        val extras = node.intent.extras
        if (extras == null || extras.isEmpty) {
            return mutableListOf()
        }

        val bundle = FlipperObject.Builder()

        for (key in extras.keySet()) {
            bundle.put(key, extras.get(key))
        }

        return mutableListOf(Named("Arguments", bundle.build()))
    }
}
```

We can actually just extend the default `ActivityDescriptor` (although for custom views you'll likely need to extend `NodeDescriptor` itself), and override the `getData` method. We just want to return a list of `Named`, which is essentially a key-value pair for what will show up in the inspector. We iterate through all the extras and build up a map, and return that as a singleton list.

Then all we have to do is register our descriptor in the code that initializes Flipper in our Application class:

```
val client = AndroidFlipperClient.getInstance(this)
val mapping = DescriptorMapping.withDefaults()
mapping.register(Activity::class.java, PlaidActivityDescriptor())
client.addPlugin(InspectorFlipperPlugin(this, mapping))
client.start()
```

And we're all set! Now we can see the extras in the inspector pane.

{% img center /images/2019/10/15/activity_args.png 800 800 Activity Arguments %}

There's a lot more customization available in Flipper, next time we'll look at building some custom plugins for further improving debugging.