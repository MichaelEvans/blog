---
layout: post
title: "Using Espresso for Easy UI Testing"
date: 2015-08-03 22:16:49 -0400
comments: true
categories: [Android, Development, Code]
description: "Using Espresso for Easy UI Testing"
keywords: "Android, Development"
---

One thing that I notice when I talk to Android developers is that a lot of them don't put an emphasis on testing. They say that it's too hard to write them or that they are too hard to integrate and set up, or give a bunch of other reasons why they don't. But it's actually pretty simple to write [Espresso](https://code.google.com/p/android-test-kit/wiki/Espresso) tests, and they really aren't that hard to integrate with your code base.

<!-- more -->

##Easy to write

Espresso tests are dead simple to write. They come in three parts.

1. ViewMatchers - something to find the view to act upon/assert something about
2. ViewActions - something to perform an action (type text, click a button)
3. ViewAssertions - something to verify what you expect

For example, the following test would type the name "Steve" into an EditText with the id `name_field`, click a Button with the id `greet_button` and then verify that the text "Hello Steve!" appears on the screen:

```java
@Test
public void testSayHello() {
  onView(withId(R.id.name_field)).perform(typeText("Steve"));
  onView(withId(R.id.greet_button)).perform(click());
  onView(withText("Hello Steve!")).check(matches(isDisplayed()));
}
```

Seems simple enough right? But what about when other threads are involved?

##Integration

From the Espresso documentation:

{% blockquote %}
The centerpiece of Espresso is its ability to seamlessly synchronize all test operations with the application under test. By default, Espresso waits for UI events in the current message queue to process and default AsyncTasks* to complete before it moves on to the next test operation. This should address the majority of application/test synchronization in your application."
{% endblockquote %}

But if you're like me, you're not writing AsyncTasks to handle your background operations. My go-to tool for making HTTP requests (probably one of the most common uses of AsyncTask) is [Retrofit](http://square.github.io/retrofit/). So what can we do? Espresso has an API called `registerIdlingResource`, which allows you to synchronize your custom logic with Espresso.

With this knowledge, one way you might approach this is to implement a mock version of your Retrofit interface, and then use something like this:

```java
public class MockApiService implements ApiService, IdlingResource {
	
	private final ApiService api;
	private final AtomicInteger counter;
	private final List<ResourceCallback> callbacks;

	public MockApiService(ApiService api) {
		this.api = api;
		this.callbacks = new ArrayList<>();	
		this.counter = new AtomicInteger(0);
	}

	@Override
	public Response doWork() {
		counter.incrementAndGet();
		return decrementAndNotify(api.doWork());
	}

	@Override
	public String getName() {
		return this.getClass().getName();
	}

	@Override
	public boolean isIdleNow() {
		return counter.get() == 0;
	}

	@Override
	public void registerIdleTransitionCallback(ResourceCallback resourceCallback) {
		callbacks.add(resourceCallback);
	}

	private <T> T decrementAndNotify(T data) {
		counter.decrementAndGet();
		notifyIdle();
		return data;
	}

	private void notifyIdle() {
		if (counter.get() == 0) {
			for (ResourceCallback cb : callbacks) {
				cb.onTransitionToIdle();
			}
		}
	}

}
```

This tells Espresso that your app is idle after the methods are called. But you should immediately see the problem here - you'll end up writing a TON of boilerplate. As you have more methods in your interface, and lot of repeated increment and decrement code...there must be a better way. (There is!)

The "trick" lies right in the selling point in the Espresso documentation, "Espresso waits for UI events... and default _**AsyncTasks**_ to complete". If we could somehow execute our Retrofit requests on the AsyncTasks' ThreadPoolExecutor, we'd get sychronization for free!

Fortunately, Retrofit's `RestAdapter.Builder` class has just such a method! 

```java
new RestAdapter.Builder()
   .setExecutors(AsyncTask.THREAD_POOL_EXECUTOR, new MainThreadExecutor())
   .build();
```

And it's that simple - Now you have no excuse not to write some Espresso tests!

####More Resources

- [The Espresso V2 Cheatsheet](https://code.google.com/p/android-test-kit/wiki/EspressoV2CheatSheet)
- [Read more about writing custom idling resources](http://blog.sqisland.com/2015/04/espresso-custom-idling-resource.html)

Thanks to [Huyen Tue Dao](https://twitter.com/queencodemonkey) for editing this post!
