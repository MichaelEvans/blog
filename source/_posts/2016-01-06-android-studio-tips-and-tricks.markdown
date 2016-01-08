---
layout: post
title: "Android Studio Tips and Tricks"
date: 2016-01-06 20:25:53 -0500
comments: true
categories: [Android, Development]
description: "Android Studio Tips and Tricks"
keywords: "Android, Development, Android Studio"
---

I recently attended Google's [Android Dev Summit](https://androiddevsummit.withgoogle.com/) where the Tools team presented a talk entitled [Android Studio For Experts](https://www.youtube.com/watch?v=Y2GC6P5hPeA). The room was packed for the 90 minute session, where a lot of great Android Studio tips where shared. This gave me the idea of showing off some of my favorite Android Studio tips!

<!-- more -->

## Language Injection

Ever needed to type a JSON string? Perhaps you've used one as a text fixture for one of your GSON deserializers and know that it's a huge pain to manage all those backslashes. Fortunately, IntelliJ has a feature called *Language Injection*, which allows you to edit the JSON fragment in its own editor and then IntelliJ will properly inject that fragment into your code as an escaped String.

Inject Language/Reference is an intention action[^1], so you can start it by using <kbd>⌥</kbd>+<kbd>Return</kbd>, or <kbd>⌘</kbd>+<kbd>⇧</kbd>+<kbd>A</kbd> and searching for it.

{% img center /images/2016/01/06/fragment_editor.png 300 300 Editing JSON %}

## [Check RegExp](https://xkcd.com/1171/)

This is pretty similar to the last tip, but if you select the language of the fragment as "RegExp", you'll get a handy regular expression tester!

{% img center /images/2016/01/06/reg_exp_1.png 300 150 Editing Regex %}

{% img center /images/2016/01/06/reg_exp_2.png 300 200 Valid Regex %}

{% img center /images/2016/01/06/reg_exp_3.png 300 200 Invalid Regex %}

## Smart(er) Completion

Now I’m pretty sure most of you have used IntelliJ’s code completion features. Press <kbd>⌥</kbd>+<kbd>Space</kbd>, and IntelliJ/Android Studio lists options to complete the names of classes, methods, fields, and keywords within the visibility scope. But have you ever noticed that the suggestions seem to be based off the characters you've typed, rather than the actual _types_ that are expected in the scope of the caret? Something like this:

{% img center /images/2016/01/06/basic_autocomplete.png 300 200 Autocomplete %}

Well if you use *Type Completion* (by pressing <kbd>⌥</kbd>+<kbd>⇧</kbd>+<kbd>Space</kbd>), you will see a list of suggestions containing only those types that are applicable to the current context. Like the example below, you'll only get types that return a `Reader`, which is the type that BufferedReaders constructor expects:

{% img center /images/2016/01/06/smart_autocomplete.png 300 200 Better Autocomplete %}

What's even cooler is that you can press it an additional time, and IntelliJ will do a deeper scan (looking at static method calls, chained expressions, etc.) to find more options for you:

{% img center /images/2016/01/06/chained_autocomplete.png 300 200 Chained Autocomplete %}

## Discovering Your Own Tips and Tricks

Another really cool feature is the *Productivity Guide*. It shows you usage statistics for a lot of IntelliJ's features, like how many keystokes have been saved or possible bugs avoided by using the various shortcuts. It's also very helpful for discovering features you might not have known about; you can scroll through the list of unused features to see what you're missing out on! To find the productivity guide, go to `Help -> Productivity Guide`.

{% img center /images/2016/01/06/productivity_guide.png 700 500 Invalid Regex %}

##Bonus Round - IntelliJ 15 Only

Did you know IntelliJ has [it's own REST client built in](https://www.jetbrains.com/idea/help/testing-restful-web-services.html)? Super handy for testing out API calls without something like [Paw](https://luckymarmot.com/paw) or [Postman](https://chrome.google.com/webstore/detail/postman/fhbjgbiflinjbdggehcddcbncdddomop?hl=en).

Have any other favorite tips or tricks? Let me know!

[^1]: [Intention Actions](https://www.jetbrains.com/idea/help/intention-actions.html) are those suggestions in the little popup menus that allow you to quick-fix things like classes that haven't been imported, etc.