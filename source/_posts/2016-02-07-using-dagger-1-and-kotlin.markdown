---
layout: post
title: "Using Dagger 1 and Kotlin"
date: 2016-02-07 13:43:25 -0500
comments: true
categories: 
---

Unless you've been hiding from all the news about Android development, you've [likely](https://medium.com/@CodingDoug/kotlin-android-a-brass-tacks-experiment-part-1-3e5028491bcc#.15w4ypfer) [heard](http://antonioleiva.com/kotlin-awesome-tricks-for-android/) [about](http://vishnurajeevan.com/2016/02/13/Using-Kotlin-Extensions-for-Rx-ifying/) [Kotlin](https://realm.io/news/oredev-jake-wharton-kotlin-advancing-android-dev/). I've been toying around with it lately (the [Kotlin Koans](https://kotlinlang.org/docs/tutorials/koans.html) are a great place to start for a beginner), and wanted to try building an app with it - until I hit a few road blocks.

Personally, I'm still a fan of Dagger 1 (or as I refer to it, [Dagger Classic](https://en.wikipedia.org/wiki/New_Coke#New_Coke_after_Coke_Classic)), and when I started working on my Kotlin app, that's what I was planning to use. I knew Annotation Processing support was a relatively new addition to Kotlin, so I began to search out some information about how to get Dagger to play nicely with the Kotlin compiler. There's a lot of information about using Dagger 2 with Kotlin, and then I stumbled upon [this article](http://www.beyondtechnicallycorrect.com/2015/12/30/android-kotlin-dagger/), which said "Unfortunately, Square’s Dagger 1 does not appear to work with Kotlin while Google’s Dagger 2 does".

Bummer.

This didn't really deter me however, because I'm stubborn like that, so I proceeded to give it a try with `kapt` anyway (which seemed like it _might_ do what I want).

###Modules

So the first thing I did was try to create the various Dagger Modules that I'd need, which is where I hit my first roadblock. Attempting to compile my module gave the following error:

`Error:Modules must not extend from other classes: org.michaelevans.example.AppModule`

My intial thought was that Kotlin was causing my Module to extend `Any`, rather than `Object`. ((Any)[https://kotlinlang.org/api/latest/jvm/stdlib/kotlin/-any/] is the root of the class hierarchy in Kotlin, similar to the way that Object is the root of the Java class hierarchy.) That didn't seem to be the issue, but rather than get hung up on this - I just converted my modules to Java classes and decided to come back to this issue later.

###@Inject

So now I had my modules set up, and I went about trying to @Inject my fields on an Activity or two. Except this yielded another problem: Kotlin doesn't have fields and we obviously can't do constructor injection on something like Activity.

I'd have to use Dagger to inject something on a property, using "method" injection like so:

`lateinit var service : MyService @Inject set`

But when you try this - you'll find out that Dagger doesn't support Method injection!

So what can we do? We can target the [annotation on the backing field](https://kotlinlang.org/docs/reference/annotations.html#annotation-use-site-targets) like this:

```
@field:Inject
lateinit var app : Application
```

And now when we compile, our dependencies are injected! Woo, progress.

###Modules (part 2)

So I was pretty pleased that I had Dagger and Kotlin playing nicely enough that I could write things other than my modules in Kotlin, and Injection was working. But it did kind of bother me that I was so close to having the ability to use Kotlin for everything - why won't these Modules play nice?

I dug into the Dagger source to find out where this error was coming from, and found [this](https://github.com/square/dagger/blob/2f9579c48e887ffa316f329c12c2fa2abbec27b1/compiler/src/main/java/dagger/internal/codegen/ModuleAdapterProcessor.java#L217). The JavaDoc for [TypeMirror's equals method] says "Semantic comparisons of type equality should instead use Types.isSameType(TypeMirror, TypeMirror). The results of t1.equals(t2) and Types.isSameType(t1, t2) may differ."

I was pretty proud of myself for finding this issue in Dagger, and was about to submit a Pull Request until I noticed...[that Jake had solved this issue about 18 months ago](https://github.com/square/dagger/commit/61e471df3891cf017755998b83839042f8455c29).

Running the `1.3-SNAPSHOT` builds of Dagger that include this patch allow my Modules to be compiled properly from Kotlin.

####In Summary

- Dagger works just fine with Kotlin (as long as you're on 1.3)
- Use annotations on the backing fields to perform injection
- Use `kapt` instead of `apt` for the scope of your `dagger-compiler` dependency
- Make sure to have the following lines in your `build.gradle`
```
kapt {
    generateStubs = true
}
``` 

Hopefully this helps others who are still using Dagger 1 and want to try out Kotlin!
