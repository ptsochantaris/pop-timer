# ``PopTimer``

That debouncing timer that we've all written 50 times already, in one place, so we can stop.

## Overview
An ultra-simple debouncing push-button / toaster / egg-timer style timer, which starts when pushed and fires its callback when it is done. Pushing it at any point restarts it.

## Topics

### Setup
- ``PopTimer/PopTimer/init(timeInterval:callback:)``

### Interacting with the timer
- ``PopTimer/PopTimer/push()``
- ``PopTimer/PopTimer/abort()``
- ``PopTimer/PopTimer/isPushed``
