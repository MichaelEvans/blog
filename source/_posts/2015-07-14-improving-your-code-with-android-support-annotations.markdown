---
layout: post
title: "Improving your code with Android Support Annotations"
date: 2015-07-14 22:46:56 -0400
comments: true
categories: [Android, Development, Code]
description: "Improving your code with Android Support Annotations"
keywords: "Android, Development"
---

If you haven't heard of the Android Support Annotations library yet, you're missing out on a neat new package that will help you catch bugs in your apps. Included in the library is a number of Java annotations, that will help Android Studio check your code for possible errors and report them to you. There are quite a few of them, so I only plan to go over a few of them here, but you should definitely [check out the docs](http://tools.android.com/tech-docs/support-annotations) for more info about the rest. 

##@NonNull / @Nullable

`@NonNull` and `@Nullable` are probably the most basic of the support annotations, but also some of the most helpful! Annotate a parameter or method with either of these to denote if the parameter or method's return value can be null or not, and voila, now Android Studio can give us a nice warning that we're doing something unsafe.

<!-- more -->

Turn this:

{% img center /images/2015/07/14/no-annotations.png 600 300 Method with no annotations %}

into this:

{% img center /images/2015/07/14/nonnull.png 600 250 with @NonNull %}

Bonus points: We can even take this example one step further with the `@CheckResult` annotation, to tell us know that the return type of this method is something that we are expected to use, rather than the method having a side effect.

{% img center /images/2015/07/14/checkreturn.png 600 300 Check that return type! %}

##@StringRes / @DrawableRes / etc.

Have you ever attempted to call `setText` on a TextView, and gotten a somewhat mysterious `android.content.res.Resources$NotFoundException: String resource ID #0x3039` exception? If you pass an integer to setText, TextView assumes it's a String resource id, and will look it up in order to set the text. If only there were a way to denote that integers are not valid ids for this method...`@StringRes` to the rescue!

```
public void setText(@StringRes int id) {
	// Do something like getString(id), etc.
}
```

Now if you try to pass a non-String resource id to this method, you get something like this:

{% img center /images/2015/07/14/stringres.png 500 200 Method takes a @StringRes id, not an int %}

(There are resouce annotations for all resoruce types, `@DrawableRes`, `@ColorRes`, `@InterpolatorRes`, etc.)

##@Keep

Today I discovered a new support annotation `@Keep`. According to the support annotation docs, this annotation hasn't been hooked up to the Gradle plugin yet[^1], but it will let you annotate methods and classes that should be retained when minimizing the app.

If you've ever messed around with the cryptic `-keep class com.foo.bar { public static <methods> }` incantations that you need to use to summon the Proguard Gods, you'll know how painful it is to rip your hair out, while trying to exclude a particular method or class from being optimized away. This handy annotation will tell Proguard to leave the method or class alone - like so:

```
public class Example {
	@Keep
	public void doSomething() {
		// hopefully this method does something
	}
	...
}
```

[^1]: [Looks like this is merged](https://android-review.googlesource.com/#/c/152983/) into the 1.3 version of the plugin

The best part is - if you're using `appcompat-v7`, you're already including `support-annotations`, so just start using them already!