---
layout: post
title: "Using Build Types with the Google Services Gradle Plugin"
date: 2016-03-31 21:11:55 -0400
comments: true
categories: [Android, Development, Gradle]
description: "Using Build Types with the Google Services Gradle Plugin"
keywords: "Android, Development"
---

If you want to integrate your Android app with most of Google Play Services nowadays, you'll find that you are instructed to set up the [Google Services Gradle plugin](https://developers.google.com/android/guides/google-services-plugin) to handle configuring dependencies. The plugin allows you to drop a JSON file into your project, and then the plugin will do a bunch of the configuration for your project, such as handling the API keys. 

This is all well and good—unless you're like me ([and countless others](https://github.com/googlesamples/google-services/issues/54)) and want to use a different configuration for your debug and release builds. This would be useful, as an example, if you use Google Play Services for GCM and would like to have development builds recieve pushes from non-production systems.

It seems that the plugin is configured in such a way that it supports build flavors, but it does not yet support build types. However, with a little Gradle magic, we can hack that support in. 

<!-- more -->

**Disclaimer: This approach worked for me—but as with any hack, it is subject to break.**

So how can we go about doing this? We want to put the debug JSON file into the root of our app module during debug builds and use the release one for release builds. If you don't do that, or if you attempt to put it in `app/debug` and `app/release`, you'll get an error that says `File google-services.json is missing from module root folder. The Google Services Plugin cannot function without it`.

This error is thrown by a task named `process{VariantName}GoogleServices`. What we could do to solve this is swap the file in before that task is run! Using a little Groovy magic, I came up with this:

```groovy
android.applicationVariants.all { variant ->
    def hackTask = task("hackGPS${variant.name.capitalize()}") << {
        copy {
            from rootProject.file("config/${variant.buildType.name}/google-services.json")
            into "${projectDir}"
        }
    }
    def googleTask = tasks.findByName("process${variant.name.capitalize()}GoogleServices")
    googleTask.dependsOn hackTask
}
```

For each one of your variants, this code will create a new task - `hackGPS{VariantName}`, which copies a `google-services.json` file from a `config` directory into the root of your app module. Then it finds the corresponding Google Services task, and hooks itself in to run right before that! Now when you assemble your application, the right `google-services.json` file will be in the right place, ready to be picked up by the plugin.

*You might also want to .gitignore the `app/google-services.json` file, so that you don't keep committing the changed file to git*

Hopefully Google will fix this issue in an upcoming release of the Google Services plugin, but until then - this technique should work!
