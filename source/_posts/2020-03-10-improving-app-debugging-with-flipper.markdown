---
layout: post
title: "Improving App Debugging with Flipper"
date: 2020-03-10 20:10:22 -0400
comments: true
categories: [Android]
description: "Improving App Debugging with Flipper"
keywords: "Android"
---

Some time last year, Facebook released a new mobile debugging tool, named [Flipper](https://fbflipper.com/). It's essentially the successor to the widely popular [Stetho](http://facebook.github.io/stetho/). Although after talking to many developers, it seems like this newer tool is relatively unknown. 

Like Stetho, Flipper has many built-in features - including a layout inspector, a database inspector and a network inspector. Unlike Stetho though, Flipper has a very extensible API which allows for tons of customization. Over the next few articles, we're going to take a look at Flipper and its plugins, the APIs it provides, and how we can leverage them to help us debug various parts of our app. This post will focus on getting set up with Flipper, as well as taking a look at two of its most useful default plugins.

## Getting Started

Getting started with Flipper is really easy:

- [Download the desktop client](https://fbflipper.com/),
- Add the dependencies in your build.gradle:
```
repositories {
  jcenter()
}

dependencies {
  debugImplementation 'com.facebook.flipper:flipper:0.33.1'
  debugImplementation 'com.facebook.soloader:soloader:0.8.2'

  releaseImplementation 'com.facebook.flipper:flipper-noop:0.33.1'
}
```
- Initialize the Flipper client when your application starts:
```
class SampleApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        SoLoader.init(this, false)

        if (BuildConfig.DEBUG && FlipperUtils.shouldEnableFlipper(this)) {
            val client = AndroidFlipperClient.getInstance(this)
            client.addPlugin(InspectorFlipperPlugin(this, DescriptorMapping.withDefaults()))
            client.start()
        }
    }
}
```

And that's it! Opening the desktop client should show you an overview of your app with the Inspector plugin configured.

## Inspector Plugin

The Inspector Plugin is similar to the one found in [Android Studio 4.0](https://developer.android.com/studio/debug/layout-inspector), but has a few neat features. I like it because it operates in real-time, and doesn't require any attaching to process in Studio every time you want to inspect a layout.

Another thing you can do in the Layout Inspector that's really cool is actually _edit_ properties! Pretty mind blowing to make tweaks in the inspector and watch the views change in realtime. It's really handy for experimenting with changing padding, and text colors. It doesn't actually edit any of your xml files, but this allows you to iterate quickly to make sure everything looks right.

Let's find a view we want to update (like our repository name): 

{% img center /images/2020/03/10/inspecting.png 800 800 %}

{% img center /images/2020/03/10/selecting.png 800 800 %}

We can click on the the color swatch to open a color picker:

{% img center /images/2020/03/10/editing.png 800 800 %}

And now when we look over at our device:

{% img center /images/2020/03/10/previewing.png 800 800 %}

Neat!

## Database Browser / Plugin

Something I've wanted for a long time was a way to view the contents of my database from Android Studio. Right now, if you want to visualize your data or try out some queries - the best solution is to pull the sqlite database file off your emulator/device and run sqlite locally. But with Flipper, there's a better way!

All we need to do is configure the database plugin, and our tables should show up right away:

```
client.addPlugin(DatabasesFlipperPlugin(context))
```

{% img center /images/2020/03/10/database_browser.png 800 800 %}

Now we can easily inspect the contents of our tables, and even run queries on the live running application! 

{% img center /images/2020/03/10/writing_queries.png 800 800 %}

I've [pushed a branch](https://github.com/MichaelEvans/architecture-components-samples/commit/274ea5702cb5f10ea13012ce6d9fc6b6896f471e) of the Github Browser Architecture Component sample with these changes to GitHub if you'd like to try it out. Next time we'll take advantage of Flipper's extensibility to create our own plugins to make debugging our app easier!




