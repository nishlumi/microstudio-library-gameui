# GameUI Library

**version:** 1.0.0

## Overview

This library allows for the easy implementation of common UI elements.

*   Buttons
*   Checkboxes
*   Text
*   Dialogs
*   Listboxes
*   Cursor movement between UIs
*   And many other UI elements

You can easily implement and manage these.

---

## Reference

Please refer to the GitHub page (https://github.com/nishlumi/microstudio-library-gameui).

## How to Use

### Basic Usage

1.  First, create an instance of the `GUISystem` class.
    *   Only instantiate `GUISystem` once during the game.
2.  Next, get the `GameUIManager` instance, which is `uimanager`.
    *   The most important class in this library is `GameUIManager`.
3.  To group UIs, add a new UI group name using `addGroup`.
    *   If you don't need to separate groups, you can use the default "default" group.
4.  Define your desired UI elements.
5.  Add the UI to a specified group using the `add` method of `GameUIManager`.
    *   By specifying the group name added with `addGroup`, you can organize UIs into any group.
6.  In the `update` function, call `GUISystem.update` and `GUISystem.uiupdate`. Call **`uiupdate` for each UI group**.
7.  In the `draw` function, call `GUISystem.uidraw`. This should also be called for each UI group.

```
init = function()
  gsys = new GUISystem()
  gsys.addFont("abcfont",10)
  
  //--GUISystem.uimanager is the GameUIManager class
  uiman = gsys.uimanager
  //---"default" is defined by default
  //---Use addGroup when you want to group UIs for each screen
  uiman.addGroup("startpage")
  //---Define the UI
  txt = new GUIText("A material design button for selecting from a list of items.",
    new Bounds(gsys.left+10,90,120,8),gsys.fonts[0],"#FFF"
  )
  //---Add the UI to the specified group in GameUIManager
  uiman.add(txt, grpname)
  //---Do the same for other UIs
  chk = new GUICheckbox("Apple",new Bounds(gsys.scr.left+10,30,75,10),false,gsys.fonts[0],"#FFF")
  uiman.add(chk, grpname)
end
update = function()
  gsys.update() //Also calls KeyManager.update internally.
  gsys.uiupdate("default")
  gsys.uiupdate("startpage")
end
draw = function()
  gsys.uidraw("default")
  gsys.uidraw("startpage")
end
```

**Key Points**

*   Define the fonts you want to use with `GUISystem.addFont`. (Add fonts in Assets as needed. `""` uses the default font).
*   `GUISystem.left/right/top/bottom` can be used to get the top, bottom, left, and right positions of the game screen.
*   The `Bounds` class is mainly used for the position and size of the UI.
*   Groups in `GameUIManager` are suitable for defining, for example, each scene (screen) of the game.

---

### Defining Cursor Movement Destinations for Game Controllers and Keyboards

With game controllers, you often move between in-game UIs using the D-pad or analog sticks.

This library allows you to easily define movement between UIs.

1.  Use the `UIGridMap` class.
2.  Use the `setDirectRound` method of each UI.

A detailed explanation is provided later for `UIGridMap`. This alone should be sufficient to handle cursor movement.

Option 2 is effective when you want to control cursor movement between UIs that cannot be controlled by option 1 alone. This is not mandatory.

---

### Number of Instances Per Class During the Game

| Class           | Number in Game | Notes                                   |
| --------------- | -------------- | --------------------------------------- |
| GUISystem       | 1              |                                         |
| GameUIManager   | 1              | Automatically instantiated in GUISystem |
| KeyManager      | 1              | Automatically instantiated in GUISystem |
| UIGridMap       | n              | 1 per UI group                          |

---

### Generating UI from JSON Data

You can also generate UIs collectively from data in JSON format.

1.  Register the JSON format data file in Assets.
2.  Load the data with `asset_manager.loadJSON`.
3.  Call `GameUIManager.addFromJSON(data)`.

You can specify everything except for work properties and callback functions.

```json
{
"controls" : [
		{
			"uitype" : 1,
			"uigroup" : "default",
			"bounds" : {
				"x": 0, "y" : 0, "w" : 8, "h" : 8
			},
			"rotate" : 0,
			"scale" : 3,
			"imagename" : "icon", 
			"imagerect" : {"x": 0, "y" : 0, "w" : 8, "h" : 8}
		},
		...
	]
}
```

*   `uitype` is mandatory.
*   If `uigroup` is omitted, it will be added to the "default" UI group.


To use it, do the following:

```
scr = new GUISystem()
asset_manager.loadJSON("testui",function(data)
  scr.uimanager.addFromJSON(data)
end
```

`GameUIManager` also has a method called `loadFromJSON`.

This method generates the UI from JSON data and returns a list of those UIs. After that, you can handle the UIs freely.

This can be used, for example, when you want to add UIs dynamically in parts.

```
asset_manager.loadJSON("one_ui",function(data)
  local partsUI = scr.uimanager.loadFromJSON(data)
  scr.uimanager.addGroup("battle")
  for ui in partsUI
    scr.uimanager.add(ui, "battle")
  end
end
```

Since each UI is not drawn on the screen unless it goes through `GameUIManager.draw`, it can also be used for temporary storage.



**`loadJSON` for Each Class**

Each class also has a `loadJSON` method that can load data files individually.

This can be used to set properties in bulk.

By creating an instance of the class first and then loading a data file individually and calling `loadJSON`, you can set properties all at once and save the trouble of defining child UIs in the source code.

### Classes Easy to Use Outside of GameUIManager

`GUIAnimationImage` and `GUIAnimationImageManager` are useful classes for bundling multiple sprite images to create animations.

Since these are not strictly game UIs, they are useful classes to use on their own without including them in the `GameUIManager` mechanism.

When incorporating them into your own classes, be sure to call the `update` and `draw` methods.

### Setting Positions with a Grid in Mind

Using the `GUISystem.pos` method, you can express positions and sizes by the number of grids based on the `unit` size.

`GUISystem` has a property called `unit`. If you set this with the `setUnit` method, you can change the unit of that `unit`.

 
```
gsys = new GUISystem()
gsys.setUnit(16)
screen.drawRect(gsys.pos(0),gsys.pos(3),gsys.pos(5),gsys.pos(5))
//---In reality, the following is specified:
screen.drawRect(0, 3*16, 5*16, 5*16)
```

In the example above, the coordinate unit is set to 16, and a rectangle is drawn.
This means a specification of width=5, height=5 from the position x=0, y=0.

The `pos` method can be used not only for positioning but also for resizing, which will make it easier to manage the specification of drawing positions in the game.


## Setting Callback Functions for Various Events

Classes that inherit from `GameUI` have a `callback` property where events are defined with the name `onxxxx`. By setting a callback function there, you can call that function after a specific operation is performed.

The events defined in `GameUI.callback` are common, so they can also be used in inherited classes.

```
btn = new GUIButton(...)
btn.callback.onclick = function()
  print("pushed button!")
end

slider = new GUISlider(...)
slider.callback.onchange = function(newval, oldval)
  print("newval=" + newval.toString() + ", oldval=" + oldval.toString())
end

chk = new GUICheckbox(...)
chk.callback.onchange = function (checked)
  print("checkbox is " + checked)
end

img = new GUIImage(...)
img.callback.onenter = function(bnd)
  print("Enter the image from (" + bnd.x.toString() + "," + bnd.y.toString() + ")")
end
```
