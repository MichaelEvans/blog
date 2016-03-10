---
layout: post
title: "Changelog for N Support Libraries"
date: 2016-03-09 19:38:46 -0500
comments: true
categories: [Android, Development]
description: "Changelog for N Support Libraries"
keywords: "Android"
---

Pssst! If you're an Android developer, you might not have heard yet...the [N Preview started today](http://android-developers.blogspot.com/2016/03/first-preview-of-android-n-developer.html)! As part of the festivities, a new alpha version of the support libraries was released. There was no changelog that I could find, so I decided to make one. Here's what has changed (so far) in the public API of a few of these libraries:

<!-- more -->

## Support-V4:

{% gist 5d7c55382198640345dc support-v4.diff %}

## AppCompat:

{% gist 5d7c55382198640345dc appcompat.diff %}

## Design:

{% gist 5d7c55382198640345dc design.diff %}

There are no API changes in RecyclerView nor my personal [favorite support library](http://michaelevans.org/blog/2015/07/14/improving-your-code-with-android-support-annotations/) - Support Annotations.