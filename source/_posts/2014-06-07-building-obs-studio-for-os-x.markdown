---
layout: post
title: "Building OBS Studio for OS X"
date: 2014-06-07 22:59:38 -0400
comments: true
categories: [OS X, Guides]
description: "Building OBS Studio for OS X"
---

Recently I've been watching a bunch of streams on [Twitch](http://www.twitch.tv/), and was investigating the best options to stream from OS X. Sadly most of the ones I found were very expensive, until I saw that [Open Broadcaster Software](http://obsproject.com/), which was previously only for Windows, was [being rewritten](https://github.com/jp9000/obs-studio) to work with OS X and Linux. However, it's still highly beta/under development and as a result, there's not a lot of documentation on how to build it.

Here's how I did it:

```
	brew install ffmpeg glew cmake qt5
	git clone https://github.com/jp9000/obs-studio.git
	cd obs-studio
	mkdir cmbuild && cd cmbuild
	export CMAKE_PREFIX_PATH=/usr/local/Cellar/qt5/5.2.1/lib/cmake
	cmake .. && make
	cpack
```

This will leave you with a disk image named `obs-studio-x64-<sha1-hash>.dmg`, which you can mount and install, just like any other OS X application.

Happy Streaming!