---
layout: post
title: "Hands on with ViewPager2"
date: 2019-02-07 21:38:07 -0500
comments: true
categories: [Android]
description: "Hands on with ViewPager2"
keywords: "Android"
---

Today Google released their alpha of [ViewPager2](https://developer.android.com/jetpack/androidx/releases/viewpager2#1.0.0-alpha01), a signal of the nail in the coffin for the original ViewPager, originally [released in 2011](https://android-developers.googleblog.com/2011/08/horizontal-view-swiping-with-viewpager.html)!

Since then, I think it's safe to say that most developers have needed to make a ViewPager. Despite how prolific it is, it certainly isn't the most straightforward widget to include. I think we all have at least once wondered whether we should use a `FragmentPagerAdapter` or a `FragmentStatePagerAdapter`. Or wondered if we can use a [ViewPager *without* Fragments](https://www.bignerdranch.com/blog/viewpager-without-fragments/). 

And API confusion aside, we've still had long standing, feature requests. [RTL support](https://issuetracker.google.com/issues/36973591)? [Vertical orientation](https://issuetracker.google.com/issues/36952939)? There are numerous [open source](https://github.com/duolingo/rtl-viewpager) [solutions](https://github.com/kaelaela/VerticalViewPager) for these, but nothing official from the support library (now AndroidX)...until now!

Let's dive in and try to set up ViewPager2! You'll need your project configured with AndroidX already, as well as supporting minSdkVersion 14 or higher.

<!-- more -->

The first thing we'll need to do is add the library to our build.gradle dependencies.

```
implementation 'androidx.viewpager2:viewpager2:1.0.0-alpha01'
```

If you're familiar with RecyclerView, setting up ViewPager2 will be very familiar. We start off by creating an adapter:

```
class CheesePagerAdapter(private val cheeseStrings: Array<String>) : RecyclerView.Adapter<CheeseViewHolder>() {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CheeseViewHolder {
        return CheeseViewHolder(LayoutInflater.from(parent.context).inflate(R.layout.cheese_list_item, parent, false))
    }

    override fun onBindViewHolder(holder: CheeseViewHolder, position: Int) {
        holder.cheeseName.text = cheeseStrings[position]
    }

    override fun getItemCount() = cheeseStrings.size
}
```

and pair it with a RecyclerView.ViewHolder.

```
class CheeseViewHolder(view: View) : RecyclerView.ViewHolder(view) {

    val cheeseName: TextView = view.findViewById(R.id.cheese_name)
}
```

Finally, just like RecyclerView, we set the adapter of our ViewPager2 to be an instance of the RecyclerView adapter. However, you'll note that there's no need for a LayoutManager.

```
viewPager.adapter = CheesePagerAdapter(Cheeses.CheeseStrings)
```

And with that, we have a working ViewPager2!

{% img center /images/2019/02/07/Horizontal.gif 600 600 Horizontal ViewPager2 %}

We can even set the orientation to scroll vertically with just one line:

```
viewPager.orientation = ViewPager2.ORIENTATION_VERTICAL
```

{% img center /images/2019/02/07/Vertical.gif 600 600 Vertical ViewPager2 %}

Based on the release notes there are a lot of issues left to fix before this moves to a final release - but this is a long awaited update for one of those oldest support library components. 

The sample code for this post can be found [here](https://github.com/MichaelEvans/ViewPager2Sample). Thanks to Chris Banes' [CheeseSquare](https://github.com/chrisbanes/cheesesquare) for the sample data for this demo!