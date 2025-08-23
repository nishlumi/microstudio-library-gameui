# GameUI Library

**version:** 1.0.1

## Overview

This is a library that allows you to easily implement common UI elements.

* Buttons
* Checkboxes
* Text
* Dialogs
* Listboxes
* Cursor movement between UI elements
* And many other UI components

You can easily implement and manage these.

---

## Reference

Please refer to the GitHub page (https://github.com/nishlumi/microstudio-library-gameui).



## How to Use

### Basic Usage

1. First, create an instance of the GUISystem class.

* Please instantiate only one GUISystem during the game.

2. If necessary, get the GameUIManager class instance, ``uimanager``. 

* The most important class in this library is ``GameUIManager``. 

3. To group UIs, add a new UI group name with ``addGroup``. 

* If you don't need to separate groups, you can use the initially prepared "default" group. 

4. Define your desired UI elements.
5. Add the UI to a specified group using the `GameUIManager`'s add method.

* By specifying the group name added with `addGroup`, you can organize UIs into any group.

6. In the update function, call `GUISystem.update` and `GUISystem.uiupdate`. **`uiupdate` is called for each UI group.**
7. In the draw function, call `GUISystem.uidraw`. This is also called for each UI group.

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

* Define the fonts you want to use with `GUISystem.addFont`. (Add fonts in Assets as needed. "" uses the default font).
* You can get the top, bottom, left, and right positions of the game screen with GUISystem.left/right/top/bottom.
* The Bounds class is mainly used for the position and size of UI elements.
* GameUIManager groups are suitable for defining, for example, each game scene (screen).

---

### Defining Cursor Movement for Game Controllers and Keyboards

With game controllers, you often move between in-game UI elements using the D-pad or analog sticks.

This library allows you to easily define movement between UI elements.

1. Use the UIGridMap class
2. Use the setDirectRound method of each UI element

A detailed explanation of UIGridMap is provided later. Basically, this alone should be sufficient to handle cursor movement.

Option 2 is useful when you want to control cursor movement between UI elements that cannot be controlled by option 1 alone. This is not required.

---

### Number of Instances of Each Class During the Game

| Class | Number in Game | Notes |
|---|---|---|
|GUISystem|1||
|GamaUIManager|1|Automatically instantiated within GUISystem|
|KeyManager|1|Automatically instantiated within GUISystem|
|UIGridMap|n|1 per UI group|

---

### Generating UI from JSON Data

You can also generate UI elements collectively from data in JSON format.

1. Register the JSON data file in Assets.
2. Retrieve the data with `asset_manager.loadJSON`.
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

GameUIManager also has a method called `loadFromJSON`.

This method generates the UI from JSON data and returns a List of the UI elements. After that, you can handle the UI freely.

It can be used when you want to dynamically add UI elements partially.

```
asset_manager.loadJSON("one_ui",function(data)
  local partsUI = scr.uimanager.loadFromJSON(data)
  scr.uimanager.addGroup("battle")
  for ui in partsUI
    scr.uimanager.add(ui, "battle")
  end
end
```

Since each UI is not drawn on the screen unless it goes through GameUIManager.draw, it can also be used for temporary storage.



**loadJSON in Each Class**

Each class also has a `loadJSON` method that can load data files individually.

This can be used to set properties all at once.

By first creating an instance of this class and then loading data files individually and calling loadJSON, you can set properties at once and save the trouble of defining child UIs in the source code.

### Classes That Are Easy to Use Outside of GameUIManager

`GUIAnimationImage` and `GUIAnimationImageManager` are useful classes for bundling multiple sprite images and animating them.

Since these are not strictly game UI, they are useful classes to use independently without including them in the `GameUIManager` mechanism.

When incorporating them into your own classes, be sure to call the `update` and `draw` methods.

### Setting Positions with a Grid in Mind

Using the `GUISystem.ulen` method, you can express positions and sizes in terms of the number of grids based on the `unit` size.

`GUISystem` has a property called `unit`. You can change the value of this `unit` by setting it with the `setUnit` method.

 
```
gsys = new GUISystem()
gsys.setUnit(16)
screen.drawRect(gsys.ulen(0),gsys.ulen(3),gsys.ulen(5),gsys.ulen(5))
//---In reality, the following is specified:
screen.drawRect(0, 3*16, 5*16, 5*16)
```

In the example above, the coordinate unit is set to 16, and a rectangle is drawn.
This means it's specified as width=5, height=5 from the position x=0, y=0.

The `ulen` method can be used not only for position but also for resizing, which will make it easier to manage the specification of drawing positions in the game.

Furthermore, there are methods that allow you to specify positions clearly from the left, right, top, and bottom of the screen.

In the example below, a rectangle is created with a position and size of 8 units x 3 from the left edge to the right, 8 units x 4 from the top edge downwards, a width of 8 units x 5, and a height of 8 units x 3.

```
gsys = new GUISystem()
local rect = new GUIRect(
  new Bounds(
    gsys.toRight(3), // instead of gsys.left + gsys.ulen(3)
    gsys.toBottom(4), // instead of gsys.top - gsys.ulen(4)
    gsys.ulen(5),
    gsys.ulen(3)
  )
)
```

* **`toRight(num)`**: Gets the X coordinate for the number of units `num` from the left edge to the right.
* **`toLeft(num)`**: Gets the X coordinate for the number of units `num` from the right edge to the left.
* **`toBottom(num)`**: Gets the Y coordinate for the number of units `num` from the top edge downwards.
* **`toTop(num)`**: Gets the Y coordinate for the number of units `num` from the bottom edge upwards.

By using these methods, you can get the position from the edge of the screen even if the screen size or aspect ratio is different, thus absorbing differences between environments.





## Setting Callback Functions for Various Events

Classes that inherit from `GameUI` have a `callback` property where events are defined with names like `onxxxx`. By setting a callback function there, you can call that function after a specific operation is performed.

The events defined in `Game.callback` are common and can be used in inherited classes.

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