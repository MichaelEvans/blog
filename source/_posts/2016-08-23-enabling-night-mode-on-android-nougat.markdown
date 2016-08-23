---
layout: post
title: "Enabling Night Mode on Android Nougat"
date: 2016-08-23 18:27:01 -0400
comments: true
categories: [Android]
description: "Enabling Night Mode on Android Nougat"
keywords: "Android"
---

If you're like me, you loved the [Night Mode feature](http://www.androidpolice.com/2016/03/09/android-n-feature-spotlight-night-mode-is-back-with-expanded-features-including-red-filter-and-brightness/) that was added to the Nougat Developer Preview a few months ago. You might have been disappointed when you found out that it was missing in later preview builds, and was probably going to be removed [because it wasn't ready](https://www.reddit.com/r/androiddev/comments/4tm8i6/were_on_the_android_engineering_team_and_built/d5igc5t).

When the source code for Nougat was released this morning, my friend [Vishnu](https://twitter.com/vishnurajeevan) found this interesting snippet in the [SystemUI source](https://android.googlesource.com/platform/frameworks/base/+/android-7.0.0_r1/packages/SystemUI/src/com/android/systemui/tuner/TunerActivity.java#42) (better known to end users as the System UI Tuner): 

```java
boolean showNightMode = getIntent().getBooleanExtra(
    NightModeFragment.EXTRA_SHOW_NIGHT_MODE, false);
final PreferenceFragment fragment = showNightMode ? new NightModeFragment()
    : showDemoMode ? new DemoModeFragment()
    : new TunerFragment();
```

Long story short, if you pass the right extras to this activity, and you'll get access to the Night Mode settings (as well as the infamous Quick Tile!). Fortunately for us, this is pretty trivial to accomplish with `adb` via `adb -d shell am start  --ez show_night_mode true com.android.systemui/.tuner.TunerActivity`, but not everyone who wants this feature is familiar with `adb`. So I published an app to the Play Store that does exactly that - click one button, and get access to those settings! You can find the app on the Play Store [here](https://play.google.com/store/apps/details?id=org.michaelevans.nightmodeenabler).