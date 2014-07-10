---
layout: post
title: "Blurred background effect for Android"
date: 2014-07-09 23:04:46 -0400
comments: true
categories: [Android, Development, Code, Github]
description: "Blurred background effect for Android"
keywords: "Android, Development, Github"
---

A few months ago, the Android design team reviewed apps that they thought were good-looking, and were referred to as the "[Beautiful Design Collection](https://play.google.com/store/apps/collection/promotion_3000235_beautiful_apps?hl=en)", as part of their [Android Design in Action](https://www.youtube.com/playlist?list=PLWz5rJ2EKKc8j2B95zGMb8muZvrIy-wcF) series.

One of these apps was [Etsy](https://play.google.com/store/apps/details?id=com.etsy.android&hl=en), which had a very cool fading blur background effect, which you can see here:

{% img center /images/2014/07/09/2014-07-09-23_25_40.gif 600 600 Etsy Example %}

As a learning experiment, I set off to replicate this behavior. I had seen a library by Manuel Peinado called [GlassActionBar](https://github.com/ManuelPeinado/GlassActionBar) which demonstrated a similar glass-like blur effect on the ActionBar, so I decided to use that code for blurring my background. 

The code itself is pretty interesting, specifically the bit for versions on Jelly Bean or higher. If you're using API version 16 and up, you can use [Renderscript Intrinsics](http://android-developers.blogspot.com/2013/08/renderscript-intrinsics.html), which are a set of built-in functions that require very little code to use, but are optimized for high-performance. 

In my sample tests, using Renderscript to blur the image took on average about ~175ms, vs ~2 seconds doing the blur using Java code. (The required code is also only a tiny fraction of the length of the Renderscript one).

Renderscript is extremely easy to add to your project, just throw 
```
        renderscriptTargetApi 19
        renderscriptSupportMode true
```
in your `build.gradle` and you should be ready to roll.

Once you have the blurring, the rest of the process is fairly straight forward. When you plan to leave an activity, create a bitmap of the current view and write it to disk. When you start your new activity (which should have a transparent background), you override the transition (otherwise you'll get the default zoom), and set the background to the blurred image you saved earlier. Add a fade in for the alpha and you get a nice little effect!

{% img center /images/2014/07/09/2014-07-09-23_34_05.gif 600 600 My Example %}

If you'd like to see how this looks in a sample project, you can find it on Github [here](https://github.com/MichaelEvans/EtsyBlurExample).