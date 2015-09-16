---
layout: post
title: "Testing Intents with Espresso Intents"
date: 2015-09-15 22:03:57 -0400
comments: true
categories: [Android, Development, Code, Testing]
description: "Testing Intents with Espresso Intents"
keywords: "Android, Development, Testing"
---

A few weeks ago, I wrote [a basic introduction](http://michaelevans.org/blog/2015/08/03/using-espresso-for-easy-ui-testing/) on how to use Espresso to test the UI of an Android application. However, sometimes your app needs to use the Android intent system to call upon the dialer, or the browser, or pick a contact with the contact picker. Because these apps run outside your application's process, you can't use Espresso to interact with them. So how can you test your app's behavior? You can either use Espresso-Intents, or UI Automator (but that's another show).

<!-- more -->

##The Setup

Setting up Espresso-Intents is dead simple if you're already using Espresso. Just add the dependency:

```
androidTestCompile 'com.android.support.test.espresso:espresso-intents:2.2.1'
```

(Make sure you're depending on Espresso, the rules and the runner already.)

##The Tests

Let's imagine that you had an application with a button to launch the contact picker, which would then show the contact Uri of the selected contact in a text view. Not only would this be hard to test because you are leaving your own application's process, but you don't even know if your test can rely on any contacts even existing on the test device (not to mention which app is registered to handle the contact picking Intent itself). Fortunately we can use Espresso-Intents to stub out the response for activities that are launched with `startActivityForResult`. 

Here's what that might look like:

```java
@Before public void stubContactIntent() {
    Intent intent = new Intent();
    intent.setData(Uri.parse(TEST_URI));
    ActivityResult result = new ActivityResult(Activity.RESULT_OK, intent);

    intending(allOf(
        hasData(ContactsContract.CommonDataKinds.Phone.CONTENT_URI),
        hasAction(Intent.ACTION_PICK))
    ).respondWith(result);
}

@Test public void pickContact_viewIsSet() {
	//Check to make sure the Uri field is empty
	onView(withId(R.id.phone_number)).check(matches(withText("")));

	//Start contact picker
	onView(withId(R.id.pick_contact)).perform(click());

	//Verify that Uri was set properly.
	onView(withId(R.id.phone_number)).check(matches(withText(TEST_URI)));
}
```

Using the `intending` API, we can respond with our mock `ActivityResult` data. If you've used [Mockito](http://mockito.org/) before, this stubbing will look very familiar to the `when`/`respondWith` methods. In this example, we're going to stub any intents for the `ACTION_PICK` intent with the `CONTENT_URI` data set to return a particular hard-coded Uri.

So this is great - our test no longer depends on any particular contact picker app, or any contacts even being present on the test device. But what do we do if we want to verify that a particular outgoing intent is launched with some given extras or data?

Let's say our sample app had an input field that would take a phone number, with a button to start the dialer to call that number. (Yes, I do realize that this application would likely not receive any venture capital funding).

All we have to do is use the `intended` API, which is most similar to Mockito's `verify` method. A sample of this might look like the following: 

```java
@Test public void typeNumber_ValidInput_InitiatesCall() {
    onView(withId(R.id.number_input)).perform(typeText(VALID_PHONE_NUMBER), closeSoftKeyboard());
    onView(withId(R.id.dial_button)).perform(click());

    intended(allOf(hasAction(Intent.ACTION_DIAL), hasData(INTENT_DATA_PHONE_NUMBER)));
}
```

In this case, we're just going to verify that the intended intent had the right action and the right data that we'd expect to hand off to the dialer.

And you'll notice that the Espresso-Intents package include handy  Hamcrest matchers for all of the parts of the `Intent` class, so you can use any of the existing Hamcrest matchers for things like Strings on the different parts of the Intent. 

Now go forth and test those inter-app component interactions!

The sample code for this blog post can be found [here](https://github.com/MichaelEvans/Espresso-Samples/tree/master/espresso-intents-sample).
