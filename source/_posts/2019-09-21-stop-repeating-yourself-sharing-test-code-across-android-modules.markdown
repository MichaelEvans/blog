---
layout: post
title: "Stop Repeating Yourself: Sharing test code across Android Modules"
date: 2019-09-21 21:34:52 -0400
comments: true
categories: [Android, Testing]
description: "Stop Repeating Yourself: Sharing test code across Android Modules"
keywords: "Android"
---

It seems like nowadays, the [best advice](https://jeroenmols.com/blog/2019/03/06/modularizationwhy/) [is to modularize](https://robinhood.engineering/breaking-up-the-app-module-monolith-the-story-of-robinhoods-android-app-707fb993a50c) [your Android app](https://www.youtube.com/watch?v=PZBg5DIzNww). It's a great suggestion for many reasons, including but not limited to:

	- improved build performance
	- enables on-demand delivery
	- pushes you to build reusable, discrete components

Sounds great, right? Are there any downsides? There is one in particular which has been a a pain point for many.

Often times when you're writing tests, you'll want to use some [test doubles](https://testing.googleblog.com/2013/07/testing-on-toilet-know-your-test-doubles.html) like fakes or fixtures in order to help simulate the system under test. Maybe you have a `FakeUser` instance that you use in your tests to avoid having to mock a `User` every time your test calls for one. Generally these classes live alongside tests in `src/test` directories and are used to test out your code within a module. 

For example, maybe you have a model object like:

```
public class User {
    private final String firstName;
    private final String lastName;

    public User(String firstName, String lastName) {
        this.firstName = firstName;
        this.lastName = lastName;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getLastName() {
        return lastName;
    }
}
```

You might have some code in `src/test` that creates a bunch of fake users for your tests like:

```
class TheOfficeFixtures {
        public static User manager = new User("Michael", "Scott");
        public static User assistantToTheRegionalManager = new User("Dwight", "Schrute");
    }
}
```

This works great if you're testing code _within_ a module, but as soon as you'd like to use these fake users in other modules, you'll note that these classes aren't shared!

This code can't be shared between modules because Gradle doesn't expose the output of your test source set as a build artifact. There are all kinds of solutions for this problem out there, including [creating a special module for all your fixtures](https://treatwell.engineering/mock-factory-for-android-testing-in-multi-module-system-7654f45808be), and using [gradle dependency hacks](https://stackoverflow.com/questions/5644011/multi-project-test-dependencies-with-gradle) to wire up source sets. 

However, that's not necessary anymore! As of version 5.6, Gradle now ships a new 'test-fixtures' plugin! This plugin creates a new `testFixtures` source set, and configures that source set so that:

	- classes in this set can see the main source set classes
	- test sources can see the test fixtures classes

### Using the Plugin

You can apply the `java-test-fixtures` plugin in your build.gradle script:

```
plugins {
    id 'java-test-fixtures'
}
```

This plugin will define the necessary source set, and handle all the wiring up of test artifacts. We can now  move those test fixtures from `src/test/java` to `src/testFixtures/java`, and that's it! These classes will be ready to be consumed by other modules. 

### Wiring it all together

Finally, we need to use a special keyword to pull these new fixtures in as a dependency for our tests. In our  gradle configuration, we add a test dependency (either API or Implementation) like so:

```
dependencies {
    testImplementation(testFixtures(project(":lib")))
}
```

And that's it! Our other module can now consume these test fixtures without any sort of intermediate modules or workarounds.

If you'd like to check out the complete configuration with examples sharing fixtures between both Kotlin and Java modules to a shared "app" module, I've uploaded a sample project demonstrating how to use this new configuration [here](https://github.com/MichaelEvans/TestFixturesExample).

## Important Caveat

It's important to note that this feature is currently only available with the `java-library` plugin, and has limited functionality in Kotlin modules, and not yet available for Android modules. There are currently feature requests on [YouTrack](https://youtrack.jetbrains.com/issue/KT-33877) and the [Android Issue Tracker](https://issuetracker.google.com/issues/139438142) to take advantage of this new functionality. 