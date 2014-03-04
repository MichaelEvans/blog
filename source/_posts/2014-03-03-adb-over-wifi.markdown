---
layout: post
title: "ADB over WiFi"
date: 2014-03-03 22:30:38 -0500
comments: true
categories: 
description: "ADB over WiFi"
keywords: "Android, Development"
---

I haven't updated my blog in a while, but this is a tip/trick that's so good that I had to share. It's not a very widely known feature, but once you try it, you'll wonder how you lived with out it: using ADB over WiFi! That's right, no more plugging in all your devices to your computer to debug/etc. Best of all, no root required.

It's also ingeniusly simple. First, connect the device you want to use via a USB cable.

```
adb tcpip 5555
(Feel free to unplug it now)
adb connect <IP address of your device>
```

That's it! Enjoy your tether-free development.