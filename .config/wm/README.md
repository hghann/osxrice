### Window manager situation

Currently, I alternate between
[Amethyst](https://github.com/ianyh/Amethyst) and
[Rectangle](https://github.com/rxhanson/Rectangle), depending on the task.
Normally, I live in a tiling window manager, but change to a "regular" window
manager when the tiling gets in the way.

#### Universal settings

No matter what window manager I am using, I have these shortcuts set in System
Preferences. These actions are not handled by both the window managers, so I
set them universally. To get a setup similar to mine, go to `System Preferences
-> Keyboard -> Shortcuts -> Mission Control` and set the following

I use the following modifier key

| Shortcut | Description |
|---|---|
| `mod` | Shift + Option |

to define the following commands

| Shortcut | Description |
|---|---|
| `mod + <-` | Move left a space |
| `mod + ->` | Move right a space |
| `mod + 1` | Switch to Desktop 1 |
| `mod + 2` | Switch to Desktop 2 |
| `mod + 3` | Switch to Desktop 3 |
| `mod + 4` | Switch to Desktop 4 |
| `mod + 5` | Switch to Desktop 5 |
| `mod + 6` | Switch to Desktop 6 |
| `mod + 7` | Switch to Desktop 7 |
| `mod + 8` | Switch to Desktop 8 |
| `mod + 9` | Switch to Desktop 9 |

#### Setup

Both window managers use a `.plist` file for configuration. To configure both window managers automatically, run

```
make wm
```

or you can go the manual route. Simply, copy the Amethyst.plist file to ~/Library/Preferences using the following command

```
cp ~/.config/amethyst/com.amethyst.Amethyst.plist ~/Library/Preferences/com.amethyst.Amethyst.plist
```

and the Rectangle.plist file to ~/Library/Preferences using the following command

```
cp ~/Library/Preferences/com.knollsoft.Rectangle.plist ~/.config/rectangle/com.knollsoft.Rectangle.plist
```
