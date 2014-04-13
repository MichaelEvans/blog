---
layout: post
title: "Embedding Google+ Posts in Octopress"
date: 2014-04-13 12:46:25 -0500
comments: true
categories: 
---

A few months back I wrote a blog post about my [2013 in Review](http://www.michaelevans.org/blog/2013/12/31/2013-in-review/). One thing I wanted to add to the post was a link to the #AutoAwesomed video, which was generated from photos and videos I took during the year, which were backed up to Google+.

Fortunately for me, Google allows you to embed posts into your pages using a technique which is documented [here](https://developers.google.com/+/web/embedded-post/). The problem with this method, for me at least, is that my blog is created using [Octopress](http://octopress.org/), and posts are written in Markdown and then rendered to HTML. Octopress does, however, allow you to write plugins which can help us with this issue.

Here's the [plugin](https://gist.github.com/MichaelEvans/10590514) in all it's glory:

{% gist 10590514 google_plus.rb %}

