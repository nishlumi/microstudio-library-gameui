# GameUI Library


## Overview

This library allows you to easily implement common UI elements.

* Buttons
* Checkboxes
* Text
* Dialogs
* Listboxes
* Cursor movement between UI elements
* And many other UI elements

You can easily implement and manage these.

---

## Usage

### Basic Usage

1. First, create an instance of the `GUISystem` class.

* Please instantiate `GUISystem` only once during the game.

2. If necessary, get the `GameUIManager` class instance, ``uimanager``.

* The most important class in this library is ``GameUIManager``.

3. To group UI elements, add a new UI group name with ``addGroup``.

* If you don't need to separate groups, you can use the "default" group that is available from the start.

4. Define the UI elements you want to use.
5. Add the UI to a specified group using the `add` method of `GameUIManager`.

* By specifying the group name added with `addGroup`, you can organize UI elements into any group.

6. In the `update` function, call `GUISystem.update` and `GUISystem.uiupdate`. **`uiupdate` must be called for each UI group.**
7. In the `draw` function, call `GUISystem.uidraw`. This also needs to be called for each UI group.

```
init = function()
  gsys = new GUISystem()
  gsys.addFont("abcfont",10)
  
  //--GUISystem.uimanager is the GameUIManager class
  uiman = gsys.uimanager
  //---"default" is defined by default
  //---Use addGroup when you want to group UI for each screen
  uiman.addGroup("startpage")
  //---Define the UI
  txt = new GUIText("A material design button for selecting from a list of items.",
    new Bounds(gsys.left+10,90,120,8),gsys.fonts[0],"#FFF"
  )
  //---Add the UI to the specified group in GameUIManager
  uiman.add(txt, grpname)
  //---Do the same for other UI elements
  chk = new GUICheckbox("Apple",new Bounds(gsys.scr.left+10,30,75,10),false,gsys.fonts[0],"#FFF")
  uiman.add(chk, grpname)
end
update = function()
  gsys.update() //This also calls KeyManager.update internally.
  gsys.uiupdate("default")
  gsys.uiupdate("startpage")
end
draw = function()
  gsys.uidraw("default")
  gsys.uidraw("startpage")
end
```

**Key Points**

* Define the fonts you want to use with `GUISystem.addFont`. (Add fonts in Assets as needed. `""` uses the default font).
* `GUISystem.left/right/top/bottom` can be used to get the top, bottom, left, and right positions of the game screen.
* The `Bounds` class is mainly used for the position and size of UI elements.
* `GameUIManager` groups are suitable for defining on a per-scene (screen) basis, for example.

---

### Defining Cursor Movement for Game Controllers and Keyboard Operation

With game controllers, you may move between in-game UI elements using the D-pad or analog sticks.

This library allows you to easily define movement between UI elements.

1. Use the `UIGridMap` class.
2. Use the `setDirectRound` method of each UI element.

A detailed explanation of `UIGridMap` is provided later. Basically, this alone should be sufficient to handle cursor movement.

2 is effective when you want to control cursor movement between UI elements that cannot be controlled by 1 alone. This is not required.

---

### Number of Instances of Each Class During the Game

|Class|Number of instances in-game|Notes|
|-|-|-|
|GUISystem|1||
|GameUIManager|1|Automatically instantiated within GUISystem|
|KeyManager|1|Automatically instantiated within GUISystem|
|UIGridMap|n|One per UI group|

---

### Generating UI from JSON Data

You can also generate UI elements in bulk from data in JSON format.

1. Register the JSON data file in Assets.
2. Load the data with `asset_manager.loadJSON`.
3. Call `GameUIManager.addFromJSON(data)`.

You can specify everything except for work properties and callback functions.

```
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

* `uitype` is required.
* If `uigroup` is omitted, it will be added to the "default" UI group.


To use it, do the following:

```
scr = new GUISystem()
asset_manager.loadJSON("testui",function(data)
  scr.uimanager.addFromJSON(data)
end
```

`GameUIManager` also has a method called `loadFromJSON`.

This method generates UI from JSON data and returns a list of the UI elements. After that, you can handle the UI freely.

This can be used when you want to dynamically add parts of the UI.

```
asset_manager.loadJSON("one_ui",function(data)
  local partsUI = scr.uimanager.loadFromJSON(data)
  scr.uimanager.addGroup("battle")
  for ui in partsUI
    scr.uimanager.add(ui, "battle")
  end
end
```

Since each UI element is not drawn on the screen unless it goes through `GameUIManager.draw`, it can also be used for temporary storage.



**loadJSON in Each Class**

Each class also has a `loadJSON` method that can load data files individually.

This can be used to set properties in bulk.

By creating an instance of this class first, then loading individual data files and calling `loadJSON`, you can set all properties at once and save the effort of defining child UI elements in the source code.

### Classes That Are Easy to Use Outside of GameUIManager

`GUIAnimationImage` and `GUIAnimationImageManager` are useful classes for bundling multiple sprite images to create animations.

Since these are not strictly game UI, they are useful classes to use on their own, without including them in the `GameUIManager` mechanism.

When incorporating them into your own classes, be sure to call the `update` and `draw` methods.

### Setting a position based on the grid

The `GUISystem` has a property called `unit`. Setting this with the `setUnit` method allows you to specify the position in that `unit` unit.

```
gsys = new GUISystem()
gsys.setUnit(16)
screen.drawRect(gsys.pos(0),gsys.pos(3),gsys.pos(5),gsys.pos(5))
//---In reality, the following is specified:
screen.drawRect(0, 3*16, 5*16, 5*16)
```

In the above example, the coordinate unit is set to 16, and a rectangle is drawn.
This means that from the position x=0, y=0, width=5, height=5 are specified.

This can be used not only for position but also for size, making it easier to manage the positioning of drawings in games.

---

## Reference

Please refer to the GitHub page (https://github.com/nishlumi/microstudio-library-gameui).