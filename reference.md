# Reference

## Classes

### Global Functions

**`drawSpritePartBounds = function(imagename, srcbnd, destbnd)`**: A `Bounds` version of `screen.drawSpritePart`. Draws a specified part of an image to a specified rectangular area.

### `Object` Extension

#### Methods

*   **`include = function (name)`**: Checks if the specified `name` exists within the object. Returns `true` if it exists, otherwise `false`. Similar to Python's `in` operator.
*   **`exclude = function (name)`**: Checks if the specified `name` does not exist within the object. Returns `true` if it does not exist, otherwise `false`.
*   **`getKey = function (val)`**: Searches for the key corresponding to the specified `val` in the object and returns the first key found. Returns an empty string if not found.
*   **`getKeys = function()`**: Returns all keys of the object as a list.

### `List` Extension

#### Methods

*   **`clear = function()`**: Removes all elements from the list, making it empty.

### `Number` Extension

#### Methods

*   **`checkRange = function (minval, maxval)`**: Checks if a number is within the specified range of `minval` and `maxval`. Returns `true` if it is within the range, otherwise `false`.

---

### `multiTextSplitter`
A global function that provides text wrapping functionality. It is specifically designed to consider the character widths of Japanese and English.

#### Properties

* **`charWidth`**: The width of a full-width character in pixels. Half-width characters are treated as half this width.
* **`charHeight`**: The height of a single line (not used in the current logic).

#### Methods

* **`isJapaneseChar(char)`**: Determines if the given character is a full-width Japanese character (Kanji, Hiragana, Katakana, or specific symbols).
* **`calcTextWidth(text)`**: Calculates the display width of the text. Full-width characters are calculated as `charWidth`, and other characters as `charWidth / 2`.
* **`splitText(text)`**: Splits text into words or characters. It splits by Japanese characters, full-width numbers, full-width alphanumeric characters, half-width alphanumeric words, punctuation, spaces, etc.
* **`wrapText(text, maxWidth)`**: Wraps text based on the specified maximum width.

---

### `Bounds`

#### Properties

* **`x`**: The X coordinate of the rectangle.
* **`y`**: The Y coordinate of the rectangle.
* **`w`**: The width of the rectangle.
* **`h`**: The height of the rectangle.

#### Methods

* **`constructor = function (x, y = 0, w = 0, h = 0)`**: Creates a new instance of a rectangular area. If the argument is an object, its properties are copied.
* **`zero = function()`**: Returns an instance of Bounds where all properties are 0. Can be used without instantiation.

---

### `GUIFPS`

A class that manages the progression of time based on the frame rate.

#### Properties

*   **`framedur`**: The duration of one frame in milliseconds.
*   **`lasttime`**: The system time of the last update.
*   **`now`**: The current system time.

#### Methods

*   **`constructor()`**: Initializes a `GUIFPS` instance.
*   **`each(val)`**: Checks if `val` frames have passed. Returns `true` and updates `lasttime` if they have, otherwise returns `false`.
*   **`update()`**: Updates the `now` property with the current system time.

---

### `GUISystem`
A class that handles basic UI system settings, coordinate transformation, and time management (via `GUIFPS`).

#### Properties

* **`left`**: The left edge of the screen coordinates.
* **`right`**: The right edge of the screen coordinates.
* **`top`**: The top edge of the screen coordinates.
* **`bottom`**: The bottom edge of the screen coordinates.
* **`oldscreen`**: A backup of the screen's width and height.
* **`unit`**: The unit (number of pixels) used for grid calculations.
* **`unitRange`**: Grid range information for the entire screen.
  - **`minx`**: Minimum grid value (x)
  - **`miny`**: Minimum grid value (y)
  - **`maxx`**: Maximum grid value (x)
  - **`maxy`**: Maximum grid value (y)
  - **`countx`**: Number of grids (x)
  - **`county`**: Number of grids (y)
* **`fps`**: An instance of the `GUIFPS` class, used for time management.
* **`fonts`**: An array of `GameFont` classes.
* **`uimanager`**: An instance of the `GameUIManager` class.
* **`keymanager`**: An instance of the `KeyManager` class.
* **`callback`**: A callback function for executing various events.
  - **`onresize(w: int, h: int)`**: Fired when the window size changes.

#### Methods

* **`constructor()`**: Initializes a `GUISystem` instance, sets coordinates, grid, and units based on the screen size, and creates a `GUIFPS` instance.
* **`setUnit(unit: Number)`**: Sets a new unit.
* **`pos(num: Number)`**: Converts the specified number of grid units to pixel coordinates and returns the value.
* **`addFont(name,size)`**: Adds a font you want to use.
* **`update()`**: Calls the `update` method of the `fps` property to update internal time management. It also saves the screen size to `oldscreen`. Returns the value from KeyManager.update.
* **`uiupdate(grp = "default")`**: Updates the UI of the specified group in the GameUIManager.
* **`uidraw(grp = "default")`**: Draws the UI of the specified group in the GameUIManager.

---

### `GameFont`

A class that holds information about the fonts used in the game.

#### Properties

* **`name`**: The name of the font.
* **`size`**: The size of the font.

#### Methods

* **`constructor(name, size)`**: Creates a new instance of a font and sets its name and size.

**Note**:
* For the standard font, the `name` can be left blank.
* For non-standard fonts, please load them as needed in Assets.

---

### `KeyElement`

Defines a single key operation (which device, which key, which action).

#### Properties

* **`ctrlname`**: The type of controller (`"k"` for keyboard, `"g"` for gamepad).
* **`keyname`**: The name of the key.
* **`action`**: The key action (`"d"` for held down, `"p"` for pressed, `"r"` for released).

#### Methods

* **`constructor(ctrler, keyname, action)`**: Creates a new instance of `KeyElement` and sets the controller name, key name, and action.

---

### `KeyManager`
A class that manages keyboard and gamepad input and checks the state of decision, cancel, directional, and custom keys. It bundles multiple `KeyElement`s to manage them as specific operations (decision, cancel, movement, etc.).

#### Properties

* **`key_decide`**: A list of decision keys (e.g., Enter key).
* **`key_cancel`**: A list of cancel keys (e.g., Escape key).
* **`key_up`**: A list of up direction keys (e.g., UP key, W key, DPAD_UP).
* **`key_down`**: A list of down direction keys (e.g., DOWN key, S key, DPAD_DOWN).
* **`key_left`**: A list of left direction keys (e.g., LEFT key, A key, DPAD_LEFT).
* **`key_right`**: A list of right direction keys (e.g., RIGHT key, D key, DPAD_RIGHT).
* **`key_custom`**: An object that stores a list of custom keys (a pair of a key name and a list of `KeyElement`s).

#### Methods

* **`constructor(parent: GUISystem)`**: Initializes a `KeyManager` instance and sets up standard key lists and an object for custom keys.
* **`_checkBody(key, action = "")`**: Checks if a key is held down (`"d"`), pressed (`"p"`), or released (`"r"`) based on the specified `KeyElement` and action. It supports both keyboard and gamepad.
* **`_keyBody(lst, action = "")`**: Iterates through a list of `KeyElement`s and checks if any key satisfies the specified action (or the default action set for the key).
* **`addCustomKey(name, lst)`**: Adds a list of custom keys associated with `name`.
* **`removeCustomKey(name)`**: Removes the custom key list for the specified `name`.
* **`is_up(action = "")`**: Checks if the up direction key satisfies the specified action (default is pressed `"p"`).
* **`is_down(action = "")`**: Checks if the down direction key satisfies the specified action.
* **`is_left(action = "")`**: Checks if the left direction key satisfies the specified action.
* **`is_right(action = "")`**: Checks if the right direction key satisfies the specified action.
* **`checkDecide(action = "")`**: Checks if the decision key satisfies the specified action.
* **`checkCancel(action = "")`**: Checks if the cancel key satisfies the specified action.
* **`checkCustom(name, action = "")`**: Checks if the custom key for the specified `name` satisfies the specified action.
* **`update()`**: Updates key operations. Returns `{x : [X-axis direction (-1 to 1)], y: [Y-axis direction (-1 to 1)] }`.

#### Note:
If you instantiate `GUISystem`, it includes this as a property, so you generally don't need to prepare it separately.

By default, operations for decision, cancel, and up/down/left/right movement are defined. To add input keys, use the `KeyElement` class and add them to `key_decide`, etc.

For game operations other than the standard ones, you can extend them by registering an operation name and a list of `KeyElement`s in `key_custom`.

Direction can be obtained as a boolean value with `is_up`, etc. If you want to get the direction as a number from -1 to 1, call `update` and refer to its return value.

```
  init = function()
    scr = new GUISystem()
    //---add custom key map for some action of a game
    scr.keymanager.addCustomKey("mapopen",[new KeyElement("k","M","p"),new KeyElement("g","Y","p"),])
  end
  update = function()
    if scr.keymanager.checkDecide() then
      some ...
    end
    if scr.keymanager.checkCustom("mapopen") then
      some ...
    end
    local dir = scr.keymanager.update()
    print(dir.x + "," + dir.y)
  end
```

---

### `TYPELIST`
An object that defines the types of UI elements. Each UI type is assigned a number.

| UI Type          | Value |
| :--------------- | :-- |
| `TEXT`           | 0   |
| `IMAGE`          | 1   |
| `CHECKBOX`       | 2   |
| `RADIOBUTTON`    | 3   |
| `RECT`           | 4   |
| `BUTTON`         | 5   |
| `SLIDER`         | 6   |
| `DIALOG`         | 7   |
| `CONTAINER`      | 8   |
| `SCROLLAREA`     | 9   |
| `LISTBOX`        | 10  |
| `ANIMATIONIMAGE` | 11  |
| `ANIMATIONMANAGER`| 12  |

### `GameUIManager`
A class that manages all UI elements of the game in groups.

#### Properties

* **`ui`**: An object that stores UI elements by group (e.g., `ui.default.element`).

#### Methods

* **`constructor(parent: GUISystem)`**: Initializes the `this.ui` object and creates a `default` group.
* **`loadFromJSON(data)`**: Generates each UI from JSON data. Returns a list of the generated UIs. This only generates the UI.
* **`addFromJSON(data)`**: Generates each UI from JSON data and also adds it to the specified UI group.
* **`getGroupCount()`**: Returns the number of managed UI groups.
* **`getCount(group = "default")`**: Returns the number of UI elements in the specified group.
* **`g(group)`**: Gets the Object of the specified group.
* **`getObject(name, group = "default")`**: Gets the UI element with the specified name from the specified group. It also searches for elements within containers and scroll areas.
* **`add(ui, group = "default", name = "")`**: Adds a UI element to the specified group. It also sets the `uigroup` and `referlist` properties of the UI element.
* **`addGroup(group)`**: Adds a new UI group.
* **`rename(name, newname, group = "default")`**: Renames a UI element within the specified group.
* **`remove(name, group = "default")`**: Removes the UI element with the specified name from the specified group.
* **`removeGroup(group)`**: Removes the specified group. The `default` group cannot be removed.
* **`getGroupItems(grpname)`**: Returns all UI elements belonging to the specified group name as a list.
* **`update(group)`**: Updates all UI elements in the specified group.
* **`draw(group)`**: Draws all UI elements in the specified group. `DIALOG` type UIs are drawn with priority over other elements.

#### Note:
Create only one global `GameUIManager` during the game, and add a group for each game scene.
Then, add and remove each UI element by specifying the group.

If you instantiate `GUISystem`, it includes this as a property, so you generally don't need to prepare it separately.

Call `update()` and `draw()` by specifying a group. (Otherwise, the UI of all scenes will always be updated.)
Calling `uiupdate` and `uidraw` in `GUISystem` is the same.

---

### `GameUI`
The base class for all UI elements.

#### Properties

* **`isOpenWindow`**: A boolean value indicating whether a window is currently open.
* **`name`**: A unique identifier for the UI element.
* **`referlist`**: A reference to the UI group to which this UI element belongs.
* **`bounds`**: The position and size of the UI element (x, y, w, h).
* **`tmpbnds`**: A copy of `bounds`.
* **`endx`**: The value of `bounds.x + bounds.w`.
* **`endy`**: The value of `bounds.y - bounds.h`.
* **`anchorx`**: The X coordinate of the anchor point.
* **`anchory`**: The Y coordinate of the anchor point.
* **`uitype`**: The type of the UI element (a value from `TYPELIST`).
* **`roundui`**: An object for referencing surrounding UI elements (for future expansion).
* **`selectable`**: A boolean value indicating whether the UI is selectable.
* **`focusable`**: A boolean value indicating whether the UI is focusable.
* **`enabled`**: A boolean value indicating whether the UI is enabled.
* **`parent`**: A reference to `GameUIManager`.
* **`keyman`**: A reference to `KeyManager`.
* **`rotate`**: The rotation angle of the UI element.
* **`scale`**: The scale of the UI element.
* **`alpha`**: The transparency of the UI element.
* **`uigroup`**: The name of the group to which this UI element belongs.
* **`tmpparam`**: A parameter area that can be used freely.
* **`fps`**: An instance of `GUIFPS`, used for time management of this UI element.
* **`font`**: The `GameFont` to be used within the UI.
* **`callback`**: An object that groups callback functions to be executed arbitrarily during various operations. Defined in inherited UIs in the `onxxxx` format.
  - **`onenter`**: Mouse cursor or tap enters the UI.
  - **`onstay`**: Mouse cursor or tap is inside the UI.
  - **`onleave`**: Mouse cursor or tap leaves the UI.
* **`old`**: An object that holds the old status (can be defined in inherited classes or used freely).
  - **`touched`**: Was it touched.
  - **`entered`**: Was the mouse or touch inside the UI.

#### Methods

* **`constructor(uitype, bounds: Bounds, rotate = 0, scale = 1)`**: Initializes the basic properties of the UI element.
* **`loadJSON(data)`**: Sets the properties of the UI from JSON data.
* **`getObject(name)`**: Gets the UI element with the specified name from `referlist` or the `contents` of a `SCROLLAREA`/`CONTAINER`.
* **`setDirectRound(label, ui)`**: Sets a UI element directly in the `roundui` object.
* **`setRound(upui = null, leftui = null, rightui = null, bottomui = null)`**: Sets the up, down, left, and right UI elements, resolving them using `getObject` if passed as strings.
* **`setPos(x,y)`**: Sets the position of the UI element.
* **`calcPosByAnchor(ax, ay)`**: Calculates the position based on the anchor point.
* **`setAnchor(x, y)`**: Sets the anchor point.
* **`setSize(w, h)`**: Sets the size of the UI element.
* **`checkTouchArea(x, y)`**: Checks if the specified coordinates are within the touch area of the UI element.
* **`update()`**: Updates the state of the UI element (calls `this.fps.update()`).
* **`draw()`**: Prepares the UI element for drawing (sets anchor, scale, rotation, alpha). The specific drawing is done in the child class.

#### Note:
By using the `UIGridMap` described later, you can move the cursor between UIs with the keyboard or gamepad.
To do this, set a reference to the destination UI for the cursor in `roundui`.
You can control the cursor more finely than just using `UIGridMap`.

---

### `GUIImage`
A UI element class for displaying images.

#### Properties

* **`imagename`**: The name of the image to display.
* **`img_bnd`**: A rectangular area for displaying a part of the image.
* **`isCutSprite`**: A boolean value indicating whether to cut out a part of the image.

#### Methods

* **`constructor(bnd: Bounds, imagename, imagerect = 0, rotate = 0, scale = 1.0)`**: Sets the image name, the rectangular area of the image to display (`imagerect`), position, size, etc. If `imagerect` is specified, a part of the sprite is cut out and displayed.
* **`setImage(newimg)`**: Sets the image to be displayed to a new image.
* **`update()`**: Calls the parent class's `update` method.
* **`draw()`**: Draws the image. Uses `drawSpritePartBounds` if `isCutSprite` is `true`, otherwise uses `screen.drawSprite`.

---

### `GUIAnimationImage`
A UI element class that manages and displays animated images.

#### Properties

* **`LOOPTYPE`**: An object that defines the loop type of the animation (`TOBEGIN`, `NOLOOP`, `REVERSE`).
* **`imagelist`**: A list of `GUIImage` objects, representing each frame of the animation.
* **`isManualAnimation`**: A boolean value indicating whether the animation is being controlled manually (`true` if playing).
* **`curImage`**: The index of the currently displayed image.
* **`looptype`**: The loop method of the animation (a value from `LOOPTYPE`).
* **`loopv`**: The playback direction of the animation (1: forward, -1: reverse).
* **`animationPeriod`**: The duration (number of frames) that each frame of the animation is displayed.

#### Methods

* **`constructor(bnd)`**: Initializes an instance of `GUIAnimationImage` and sets the animation frame list, loop settings, etc.
* **`loadJSON(data)`**: Loads properties from a JSON object.
* **`addImage(img)`**: Adds a `GUIImage` to the animation. The bounds of the added image are adjusted to the bounds of the animation image itself.
* **`removeImage(index)`**: Removes the image at the specified index from the animation.
* **`play()`**: Plays the animation from the beginning.
* **`stop()`**: Stops the animation playback.
* **`playToggle()`**: Toggles the play/pause of the animation.
* **`update()`**: If the animation is playing, proceeds to the next frame based on the set period. Adjusts the playback direction and index according to the loop type.
* **`draw()`**: Draws the image of the currently displayed animation frame.

---

### `GUIAnimationImageManager`
A class that manages multiple animated images and switches the currently displayed animation.

#### Properties

* **`moveDict`**: An object that manages animated images (`GUIAnimationImage`) by name.
* **`curMove`**: The name of the currently displayed animation.

#### Methods

* **`constructor(bnd: Bounds)`**: Initializes an instance of `GUIAnimationImageManager` and sets the animation dictionary and the current movement.
* **`cur(name)`**: Returns the animated image with the specified name.
* **`setCur(name)`**: Sets the currently displayed animation to the specified name.
* **`addAnimation(name)`**: Creates a new animated image and adds it to the management list with the specified name.
* **`removeAnimation(name)`**: Removes the animated image with the specified name from the management list.
* **`update()`**: Calls the `update` method of the currently displayed animated image.
* **`draw()`**: Calls the `draw` method of the currently displayed animated image.

#### Note:
You can control various animations together by using `GUIAnimationImage` and `GUIAnimationImageManager`.
The usage flow is as follows.

```
//---GUIAnimationImageManager & GUIImage
  aimgman = new GUIAnimationImageManager(new Bounds(-60,0,128/4, 192/4))

  //---to generate GUIAnimationImage in GUIAnimationImageManager
  aimgman.addAnimation("bottom")
  aimgman.moveDict["bottom"].addImage([
    //---
    new GUIImage(new Bounds(0,0,0,0), "ch03_elenoa", new Bounds(32*0, 0, 128/4, 192/4)),
    new GUIImage(new Bounds(0,0,0,0), "ch03_elenoa", new Bounds(32*1, 0, 128/4, 192/4))
    new GUIImage(new Bounds(0,0,0,0), "ch03_elenoa", new Bounds(32*2, 0, 128/4, 192/4)),
    new GUIImage(new Bounds(0,0,0,0), "ch03_elenoa", new Bounds(32*3, 0, 128/4, 192/4))
  ])
  aimgman.moveDict["bottom"].looptype = GUIAnimationImage.LOOPTYPE.TOBEGIN
  
  aimgman.addAnimation("left")
  aimgman.moveDict["left"].addImage([
    new GUIImage(new Bounds(0,0,0,0), "ch03_elenoa", new Bounds(32*0, 48, 128/4, 192/4)),
    new GUIImage(new Bounds(0,0,0,0), "ch03_elenoa", new Bounds(32*1, 48, 128/4, 192/4)),
    new GUIImage(new Bounds(0,0,0,0), "ch03_elenoa", new Bounds(32*2, 48, 128/4, 192/4)),
    new GUIImage(new Bounds(0,0,0,0), "ch03_elenoa", new Bounds(32*3, 48, 128/4, 192/4))
  ])
  aimgman.moveDict["left"].looptype = GUIAnimationImage.LOOPTYPE.TOBEGIN
  
  uiman.add(aimgman)

  //---decide current animation
  aimgman.curMove = "bottom"
```

`GUIAnimationImageManager` can manage multiple `GUIAnimationImage`s. By specifying the animation name in `addAnimation`, it generates and holds a `GUIAnimationImage` internally.

That `GUIAnimationImage` can manage multiple `GUIImage`s to construct a single animation.
(If you are creating animations in the Sprites panel, you may only need one `GUIImage`.)

When actually using it in a game, you can switch animations at any time by setting the animation name in `GUIAnimationImageManager.curMove`.

```
update = function()
  if keymanager.is_left() then
    aimgman.curMove = "left"
  end
  if keymanager.is_right() then
    aimgman.curMove = "right"
  end
end
```

- For a code sample, please see `GUIAnimationImageManager & GUIImage` in `example.ms`.

---

### `GUIText`
A UI element class for displaying text.

#### Properties

* **`wrapper`**: An object that handles text wrapping using `multiTextSplitter`.
* **`is_wrap`**: A boolean value indicating whether to wrap text.
* **`realtexts`**: A list that stores the text lines after wrapping.
* **`text`**: The content of the text to display.
* **`color1`**: The main color of the text.
* **`color2`**: The shadow color of the text.
* **`shifted`**: The offset of the shadow (x, y).
* **`font`**: The font object to use.
* **`blink_time`**: The blink time (not directly used in the current code).
* **`callback`**: Events
  - **`onchange(newtext, oldtext)`**: The content of the text has changed.

#### Methods

* **`constructor(text, bnd: Bounds, font = 0, color1 = 0, color2 = 0,shifted_x = 0, shifted_y = 0)`**: Sets the text content, bounds, font, colors, etc.
* **`loadJSON(data)`**: Loads properties from a JSON object.
* **`setText(txt)`**: Sets the text and recalculates wrapping if necessary.
* **`recalcWrap()`**: Recalculates text wrapping.
* **`refreshText(width)`**: Recalculates text wrapping based on the width.
* **`update()`**: Calls the parent class's `update` method.
* **`draw()`**: Draws the text. It can also draw a shadow-like effect based on the `shifted` property.

#### Note:
`GUIText` has a built-in `multiTextSplitter` library to control wrapping.

In addition, you can change the font or specify `shifted_x` and `shifted_y` to draw a shifted shadow.

---

### `GUICheckbox`
A UI element class with a checked state.

#### Properties

* **`pressed`**: A boolean value indicating whether the checkbox is pressed.
* **`checked`**: A boolean value indicating whether it is checked.
* **`text`**: A `GUIText` instance used as the label for the checkbox.
* **`checkColor`**: The color of the checkbox.
* **`callback`**: Events
  - **`onchange(checked: boolean)`**: The state of the checkbox has changed.

#### Methods

* **`constructor(text, bnd: Bounds, chked = 0, font = 0, color1 = 0, color2 = 0,shifted_x = 0, shifted_y = 0)`**: Sets the text, bounds, initial checked state, font, colors, etc.
* **`loadJSON(data)`**: Loads properties from a JSON object.
* **`setFont(font: GameFont)`**: Sets the font for the text label.
* **`checkTouchArea(x, y)`**: Checks the touch area that includes both the checkbox body and the text.
* **`check()`**: Toggles the checked state.
* **`uncheck()`**: Sets the checked state to `false`.
* **`update()`**: Toggles the state of the checkbox when the mouse or touch is released.
* **`draw()`**: Fills a square or draws a border depending on the checked state, and also draws the label text.

#### Note:
To get the checked state, refer to `checked`.

---

### `GUIRadiobutton`
A UI element class where only one can be selected within a group.

#### Properties

* **`pressed`**: A boolean value indicating whether the radio button is pressed.
* **`checked`**: A boolean value indicating whether it is checked.
* **`text`**: A `GUIText` instance used as the label for the radio button.
* **`checkColor`**: The color of the radio button.
* **`group`**: The name of the group to which the radio button belongs.
* **`callback`**: Events
  - **`onchange(value: string)`**: The state of the radio button has changed (event occurs only for the UI where `checked` is `true`. `value` is the UI name).

#### Methods

* **`constructor(text, grpname, bnd: Bounds, chked = 0, font = 0, color1 = 0, color2 = 0,shifted_x = 0, shifted_y = 0)`**: Sets the text, group name, bounds, etc.
* **`loadJSON(data)`**: Loads properties from a JSON object.
* **`setFont(font: GameFont)`**: Sets the font for the text label.
* **`checkTouchArea(x, y)`**: Checks the touch area that includes both the radio button body and the text.
* **`check()`**: Checks this radio button and unchecks other radio buttons in the same group.
* **`uncheck()`**: Sets the checked state to `false`.
* **`getGroupValue()`**: Returns the `name` of the UI that is true in the radio button group.
* **`update()`**: Toggles the state of the radio button when the mouse or touch is released. It also manages the checked state of other radio buttons in the same group.
* **`draw()`**: Fills a circle or draws a border depending on the checked state, and also draws the label text.

#### Note:
* By specifying a `group`, it becomes mutually exclusive.
* To get the checked state, refer to `checked`.
* To move the cursor between radio button items, use `UIGridMap` or set `roundui` for each UI element.

---

### `GUIRect`
A UI element class for drawing a simple rectangle.

#### Properties

* **`color`**: The color of the rectangle.
* **`filled`**: A boolean value indicating whether to fill the rectangle.
* **`radius`**: The corner radius of the rectangle.
* **`transparency`**: The transparency of the rectangle.
* **`transparencyInterval`**: The interval for transparency changes.

#### Methods

* **`constructor(bnd: Bounds, color, filled = true, radius = 0, transparency = 1, transparency_interval = 0)`**: Sets the bounds, color, fill, corner radius, transparency, etc.
* **`loadJSON(data)`**: Loads properties from a JSON object.
* **`update()`**: Calls the parent class's `update` method.
* **`draw()`**: Fills or draws a border for the rectangle (including rounded rectangles) based on the settings.

---

### `GUIButton`
A UI element class for a clickable button.

#### Properties

* **`pressed`**: A boolean value indicating whether the button is pressed.
* **`filled`**: A boolean value indicating whether to fill the button's background.
* **`radius`**: The corner radius of the button.
* **`text`**: A `GUIText` instance used as the label for the button.
* **`bgcolor`**: The background color of the button.
* **`pushbgcolor`**: The background color when the button is pressed.
* **`curBgcolor`**: The current background color.
* **`callback`**: Events
  - **`onpress`**: Executed when the button is pressed.
  - **`onpressing`**: Executed while the button is being pressed. Occurs continuously while pressed.
* **`shadow`**: Settings for the button's shadow (offset, color).

#### Methods

* **`constructor(text, bnd, font = 0, bgcolor = "#FF0", pushbgcolor = "#CC0", fontcolor = "#000", filled = true, radius = 0, callback = 0)`**: Sets the text, bounds, font, background color, pressed background color, font color, fill, corner radius, callback function, etc.
* **`loadJSON(data)`**: Loads properties from a JSON object.
* **`setFont(font: GameFont)`**: Sets the font for the text label.
* **`checkTouchArea(x, y)`**: Checks the touch area that includes both the radio button body and the text.
* **`push()`**: Manually triggers the button's callback.
* **`update()`**: Updates the state of the button when the mouse or touch is released, and executes the callback if pressed.
* **`draw()`**: Draws the button's shadow and body, and also draws the text.

#### Note:
For the event when the button is pressed, you can easily execute any process by specifying `function end` in `callback`.

You can also execute your own events by manually checking `pressed`. You can also call the callback function at any time with the `push` method.

```
init =  function()
  btn1 = new GUIButton(...)
  btn1.callback = function()
    print("push!")
  end
end
update = function()
  if btn.pressed then
    some ...
  end
end
```

---

### `GUISlider`
A slider UI element class for adjusting a value.

#### Properties

* **`pressed`**: A boolean value indicating whether the slider bar is currently pressed.
* **`presspos`**: The mouse/touch coordinates when the bar is pressed.
* **`barcolor`**: The normal color of the slider bar.
* **`pushbarcolor`**: The color of the slider bar when it is pressed.
* **`curBarcolor`**: The current color of the bar (`barcolor` or `pushbarcolor`).
* **`bgcolor`**: The background color of the slider's meter.
* **`minvalue`**: The minimum value the slider can take.
* **`maxvalue`**: The maximum value the slider can take.
* **`step`**: The step amount for adjusting the slider's value.
* **`value`**: The current value of the slider.
* **`old.value`**: The old value.
* **`isVertical`**: A boolean value indicating whether the slider is vertical (`true` for vertical, `false` for horizontal).
* **`label`**: Settings for the label that displays the slider's current value (`enable` on/off, `size`, `x`/`y` position, `color`).
* **`barbnd`**: A `Bounds` object indicating the position and size of the slider bar.
* **`real_x`**: The X coordinate used for internal calculations of the slider (Y coordinate for vertical).
* **`callback`**: Events
  - **`onchange(newval, oldval)`**: The value of the slider has changed.

#### Methods

* **`constructor(bnd: Bounds, defaultval, minval, maxval, step, isVertical = false, bgcolor = "#999", barcolor = "#EEE", pushbarcolor = "#FFF")`**: Initializes a slider instance and sets the bounds, default value, min/max values, step, orientation, colors, etc.
* **`loadJSON(data)`**: Loads properties from a JSON object.
* **`setValue(val)`**: Increases or decreases the slider's value by `val` and clamps it within the `minval` and `maxval` range.
* **`calclateBarPosition(x, y)`**: Calculates the position of the slider bar and the corresponding `curval` based on the mouse/touch coordinates.
* **`update()`**: Updates the state of the slider bar (pressed state, color, value) based on mouse or touch input.
* **`draw()`**: Draws the slider's meter (background) and bar. It is drawn as a vertical or horizontal slider depending on the `isVertical` property, and the label is also displayed.

#### Note:
By default, it is a landscape slider, but if you set the argument `isVertical` to true during creation, it becomes a portrait slider.
Please set the `w` and `h` of the Bounds specified in `bnd` during creation so that they have the respective orientation.

```
// horizontal
sld = new GUISlider(new Bounds(0,0,70,20),0,0,50,1,false)
                                   ^^ ^^
// vertical
sld = new GUISlider(new Bounds(0,0,20,70),0,0,50,1,true)
                                   ^^ ^^
```

---

### `GUIDialog`
A UI element class for a pop-up dialog window.

#### Properties

* **`BTNLIST`**: An object that defines the types of buttons displayed in the dialog (OK, YESNO, YESNOCANCEL, CUSTOM).
* **`color`**: The background color of the dialog.
* **`contents`**: A list of UI elements displayed within the dialog.
* **`font`**: The font used within the dialog.
* **`buttons`**: A list of the dialog's buttons.
* **`btntype`**: The type of buttons to display in the dialog (a value from `BTNLIST`).
* **`drawtime`**: The number of frames for the dialog's opening animation.
* **`drawpart`**: The increment for each frame in the dialog's drawing animation (x, y).
* **`curdraw`**: The current frame number of the drawing animation.
* **`is_startdraw`**: A boolean value indicating whether the dialog's drawing animation has started.
* **`is_drawend`**: A boolean value indicating whether the dialog's drawing animation has finished.
* **`callback`**: Events
  - **`onopen()`**: The dialog has opened.
  - **`onclose()`**: The dialog has closed.

#### Methods

* **`constructor(bnd: Bounds, btns = 0, font)`**: Sets the bounds, button type, font, etc., and initializes the dialog's initial state (content, buttons, animation-related properties).
* **`loadJSON(data)`**: Loads properties from a JSON object.
* **`generateBtn()`**: Generates OK, YES/NO, YES/NO/CANCEL buttons based on `btntype` and adds them to the `buttons` list.
* **`addContents(ui)`**: Adds a UI element inside the dialog and adjusts its position to fit the dialog's content area. It also handles wrapping for text.
* **`recalcText(index)`**: Recalculates the wrapping of the text UI element at the specified index.
* **`checkPressed()`**: Returns an object indicating which button in the dialog was pressed (e.g., `{ ok: true }`).
* **`checkKeys()`**: Returns an object indicating which button in the dialog was pressed based on input from the key manager.
* **`open()`**: Opens the dialog and starts the drawing animation. Sets `GameUI.isOpenWindow` to `true`.
* **`isOpen()`**: Returns whether the dialog's opening animation has finished.
* **`close()`**: Closes the dialog, resets the drawing state, and sets `GameUI.isOpenWindow` to `false`.
* **`update()`**: Processes the dialog's drawing animation, and after the drawing is finished, updates the internal UI elements and buttons.
* **`draw()`**: Draws the dialog's background and content. It is partially drawn during the opening animation, and after the animation is finished, the entire screen is covered with a semi-transparent background before drawing the dialog.

#### Note (Basic):
* You can add UI elements other than text to `contents`.

* The dialog is not displayed on the screen until it is opened. It will be used by displaying it in combination with a keyboard, buttons, etc.

```
dlg1 = new GUIDialog(new Bounds(0,0,150,65),GUIDialog.BTNLIST.OK,this.font)

update = function()
  if keyboard.O then
    dlg1.open()
  end
  if keyboard.Q then
    dlg1.close()
  end
  dlg1.update()
end
```

#### Note (Usage as a dialog):

The dialog can display buttons to be used in addition to `contents`. Set the value of `BTNLIST` to `btns` during creation according to the purpose.

* OK button only: `GUIDialog.BTNLIST.OK`
* Yes, No buttons: `GUIDialog.BTNLIST.YESNO`
* Yes, No, Cancel buttons: `GUIDialog.BTNLIST.YESNOCANCEL`
* No buttons: `GUIDialog.BTNLIST.CUSTOM`

The return values of these buttons in the dialog are obtained with the `checkPressed` or `checkKeys` methods.

The return value is in the following format. Basically, you judge with `checkPressed()`.

```
init = function()
  //uiman is GameUIManager
  keyman = new KeyManager()
  dlg = new GUIDialog(...)
  uiman.add(dlg,"firstscreen")
end
update = function()
  chk = dlg.checkPressed()
  if chk.ok then
  end
  if chk.yes then
  end
  if chk.no then
  end
  if chk.cancel then
  end
  if chk.actioned then //---when some button is pressed
  end

  dlg.checkKeys()
end
```

By using `checkKeys()`, you can get input from the keyboard or gamepad and operate the buttons as they are.
The return value of `checkKeys()` is the same as `checkPressed()`. This allows the buttons to correspond as follows, even if the actual keys for the decision key and cancel key are different in the game.

* OK button: Decision key
* Yes button: Decision key
* Cancel button: Cancel key

For example, to close the dialog when any button is pressed, you need to implement it as follows.

```
local dlgret = dlg.checkKeys()
if dlgret.actioned then
  dlg.close()
end
```

---

### `GUIContainer`
A general-purpose container class for grouping multiple UI elements.

#### Properties

* **`color`**: The background color of the container.
* **`filled`**: A boolean value indicating whether to fill the container.
* **`radius`**: The corner radius of the container.
* **`contents`**: A list of UI elements contained within the container.
* **`font`**: The font used within the container.

#### Methods

* **`constructor(bnd: Bounds, font, bgcolor = "#FFF")`**: Sets the bounds, font, background color, etc.
* **`loadJSON(data)`**: Loads properties from a JSON object.
* **`addContents(ui)`**: Adds a UI element inside the container and adjusts its position. It also handles wrapping for text.
* **`recalcText(index)`**: Recalculates the wrapping of the text UI element at the specified index.
* **`update()`**: Calculates the position of the internal UI elements and updates them.
* **`draw()`**: Draws the container's background and internal UI elements.

#### Note:
This is a general-purpose class that can contain other UI elements. To draw the container itself, specify a color for `color` and `filled`.

Also, `GUIContainer` can be used as a child element of `GUIScrollArea`.

```
local cont = new GUIContainer(new Bounds(0,0,8,30),this.font,"#A88")
local txt = new GUIText("foo bar baz:" + param,new Bounds(2,5,80,20),this.font,"#FFF")
cond.addContents(txt)
```

---

### `GUIScrollArea`
An area class for scrolling and displaying internal UI elements.

#### Properties

* **`color`**: The background color of the scroll area.
* **`filled`**: A boolean value indicating whether to fill the scroll area.
* **`radius`**: The corner radius of the scroll area.
* **`contents`**: A list of all UI elements within the scroll area.
* **`show_contents`**: A list of currently displayed UI elements.
* **`font`**: The font used within the scroll area.
* **`cury`**: The starting index of the displayed content.
* **`maxy`**: The ending index of the displayed content.
* **`first_content`**: A reference to the first content element.
* **`last_content`**: A reference to the last content element.
* **`show_row`**: The number of content items to display in one row.
* **`item_margin`**: The margin between items (x, y).
* **`oldtouches`**: An object that records the previous touch coordinates (x, y).
* **`callback`**: Events
  - **`onscroll(y)`**: Scrolled.

#### Methods

* **`constructor(bnd: Bounds, font, bgcolor = "#FFF")`**: Sets the bounds, font, background color, etc.
* **`loadJSON(data)`**: Loads properties from a JSON object.
* **`calculatePos()`**: Calculates the first and last elements of the content.
* **`clearContents()`**: Clears all content within the scroll area and resets related properties.
* **`addContents(ui)`**: Adds a UI element to the scroll area. Adjusts the width to fit the display area and also adds it to `show_contents`.
* **`recalcText(index)`**: Recalculates the wrapping of the text UI element at the specified index.
* **`scrollY(y)`**: Scrolls the content by the specified scroll amount. Updates `cury` and `maxy` and rebuilds `show_contents`.
* **`update()`**: Processes scrolling based on mouse wheel or touch swipe input and updates the position of the displayed content.
* **`draw()`**: Draws the background of the scroll area and the currently displayed UI elements.

#### Note:
If a child element exceeds its own drawing area `bounds`, the exceeding element will be hidden. You can scroll with the mouse wheel or swipe to display the remaining child elements.

Child elements must have the same width and height. It is recommended to use the following generation process.

Use a function to generate child elements in a fixed form.
It is recommended that the child element be a `GUIContainer`. It is easier to manage by adding text and buttons as child elements of `GUIContainer`.
There are no restrictions on the child elements of `GUIContainer`.

It is also recommended to set the anchor to the upper left (x=-1, y=1) to make it easier to understand.

```
create_childcont = function (param)
  //---Child for GUIScrollArea
  local cont = new GUIContainer(new Bounds(0,0,70,30),this.font,"#A88")
  cont.setAnchor(-1,1)
  cont.name = "container_" + n
  local txt = new GUIText("foo bar baz:" + param,new Bounds(2,5,80,20),this.font,"#FFF")
  //---change both anchor (x, y)
  txt.setAnchor(-1,1)
  cont.addContents(txt)
  return cont
end
scrl = new GUIScrollArea(new Bounds(0,0,142,100),this.font, "#855")
scrl.addContents(create_childcont(1))
scrl.addContents(create_childcont(2))
scrl.addContents(create_childcont(3))
...
```

#### Note (Position of child elements of `GUIContainer` and `GUIScrollArea`):

The position of child elements is calculated based on the Bounds of the parent `GUIContainer` or `GUIScrollArea`. The new Bounds() specified for the child element at the time of declaration specifies the relative position from the parent element.

---

### `GUIListBox`
A list box UI element class that inherits from `GUIScrollArea` and has selectable items.

#### Properties

* **`uitype`**: The type of the UI element (`TYPELIST.LISTBOX`).
* **`pushbgcolor`**: The background color when an item is pressed.
* **`fontcolor`**: The font color of the items.
* **`selectcolor`**: The background color of the selected item.
* **`itemheight`**: The height of each item.
* **`item_str`**: An array of strings displayed in the list box.
* **`selectIndex`**: The index of the currently selected item.
* **`old.selectIndex`**: The old index.
* **`callback`**: Events
  - **`onchange(newval, oldval)`**: A callback function to be executed upon selection. Not executed when using the `select` method.

#### Methods

* **`constructor(bnd: Bounds, font, items = [], bgcolor = "#FFF", pushbgcolor = "#AAA", fontcolor = "#000", selcolor = "rgba(100,100,100,0.2)")`**: Initializes a list box instance and sets the bounds, font, items, colors, etc. Calls the parent class's constructor and sets `uitype` to `TYPELIST.LISTBOX`.
* **`loadJSON(data)`**: Loads properties from a JSON object.
* **`generate_item(lststr, itemheight)`**: Generates list box items based on the specified string list and item height. Clears existing items and adds each item as a `GUIButton`.
* **`select(index)`**: Selects the item at the specified index. Returns `true` if the index is within a valid range, otherwise `false`.
* **`update()`**: Calls the parent class's `update` method and updates `selectIndex` based on the clicked item.
* **`draw()`**: Calls the parent class's `draw` method, and if the selected item is within the visible area, draws the selection color on the background of that item.

#### Note:
Unlike the parent `GUIScrollArea`, it is generated with a list of strings `items` as an argument.
The child elements become selectable items and can be selected with the cursor, mouse, or tap.
Of course, you can also scroll to display the remaining items.

---

### `UIGridMap`
Manages cursor movement between UIs.

#### Properties

* **`uimanager`**: An instance of `GameUIManager`, used for managing UI elements.
* **`keymanager`**: An instance of `KeyManager`, used for managing key input.
* **`map`**: A 2D array of UI elements (or their string names).
* **`uigroup`**: The name of the UI group that this grid map operates on.
* **`cursor`**: A `Bounds` object indicating the currently selected UI element.
* **`cursorColor`**: The color of the cursor.
* **`cursorAlpha`**: The transparency of the cursor.
* **`cursorAlphaVelocity`**: The speed of change of the cursor's transparency.
* **`select`**: The currently selected UI element.
* **`enable_cursor`**: A boolean value indicating whether to enable the display of the cursor.
* **`framedur`**: The duration per frame in milliseconds.
* **`lasttime`**: The system time at the previous update.
* **`now`**: The current system time.

#### Methods

* **`constructor(uiman: GameUIManager, keyman: KeyManager, group)`**: Initializes a `UIGridMap` instance and sets the UI manager, key manager, the UI group to be operated on, the map, and cursor-related properties.
* **`generate_fromcsv(csv)`**: Generates a map from CSV data (comma-separated).
* **`appendRow(cols)`**: Adds a new row to the map.
* **`select(x, y)`**: Selects the UI element at the specified map coordinates.
* **`getIndex(ui)`**: Returns the index (x, y) of the specified UI element on the map.
* **`uiOpertionCheck(dirx, diry)`**: Checks UI operations (cursor movement and mouse/touch hits). It searches for a UI element that can be moved to in the direction specified by `dirx` and `diry`, and processes selection by mouse/touch input. It also attempts to move to an adjacent element using the `roundui` property of the UI element.
* **`update()`**: Processes the cursor's blinking animation and decision key input for the selected UI element (checkbox or radio button).
* **`draw()`**: If the cursor is enabled, draws a cursor around the selected UI element.

#### Note:
By using `UIGridMap` for each UI group, you can control cursor movement between UI elements on the screen.

You can register a list of columns with `appendRow` or register them all at once with `generate_fromcsv`.
In the case of `generate_fromcsv`, you need to pass the names of the UI elements as a list of strings.

The following can be registered:
* The `name` of the UI element
* The UI element itself (`appendRow` only)

```
init = function()
  gridmap = new UIGridMap(this.uiman, this.keyman, this.grpname)
  gridmap.appendRow([chk,"",""])
  gridmap.appendRow(["radio01","",""])
  gridmap.appendRow(["radio02","",""])
  gridmap.appendRow([sld,btn_scrup,btn_scrdown])
  //---or
  local csv = [
    [this.chk.name,"","",""],
    [this.chk.name,"","",""],
    [this.rad1.name,"","",""],
    [this.rad2.name,"","",""],
    [this.sld.name,this.btn_scrdown.name,this.btn_scrup.name]
  ]
  this.gridmap.generate_fromcsv(csv)
  //---finally config
  this.gridmap.enable_cursor = true
end
update = function()
  this.uiman.update("default")
  local dir = this.keyman.update()
  gripdmap.uiOpertionCheck(dir.x, dir.y)
  gridmap.update()
end
draw = function()
  this.uiman.draw("default")
  gridmap.draw()
end
```

* To actually display the cursor and draw its movement, set the `enable_cursor` property to `true`.
* In the update function, pass the direction information returned from `KeyManager.update` to `UIGridMap.uiOperationCheck` for judgment.
* Call `UIGridMap.update` after `UIGridMap.uiOperationCheck`.

#### Fine control:
In the example above, you cannot move the cursor from `chk` to `btn_scrdown`. To control cursor movement between specific UI elements, do the following.

Set the name of the target UI element or the element itself to the properties of each direction of `roundui` inherited from `GameUI`. You can specify the direction and the destination UI with the `setDirectRound` method.

```
chk.setDirectRound("right",btn_scrdown)
btn_scrdown.setDirectRound("up",chk)
//---same
chk.setRound(null,null,btn_scrdown,null)
btn_scrdown(chk,null,null,null)
```

By doing this, you can move from `chk` to `btn_scrdown` by pressing the right key.

---

### `GUITextMessage`
A class that holds messages and manages the animation of displaying them one character at a time. Inherits from `GUIContainer`.

#### Properties
* **`messages`**: A list of sentences to display.
* **`alltext`**: A `GUIText` that holds the full text of the current message. For internal reference.
* **`showtext`**: A `GUIText` that holds the text currently being displayed on the screen. For internal reference.
* **`is_forwarding`**: A flag indicating whether the text forwarding animation is running. Becomes `false` when the end of `messages` is reached.
* **`curmsg_index`**: The index of the currently displayed message in `messages`.
* **`drawtime`**: The number of frames it takes to draw.
* **`callback`**: Events
  - **`onpageend(pageindex, pagetext)`**: A callback function to be executed when one page has finished drawing.

#### Methods
* **`constructor = function(bnd: Bounds, textlst = [], font = 0, fontcolor)`**: Instantiates a `GUITextMessage`.
* **`loadJSON(data)`**: Loads properties from a JSON object.
* **`setMessageList(msgs)`**: Sets the list of messages to display.
* **`goForward(dir)`**: Proceeds to the next (1) or previous (-1) message and starts the animation.
* **`goFirst(is_cleartext = false)`**: Returns to the very first message. If you want to clear the currently displayed message while returning, set `is_cleartext` to true.
* **`update()`**: Adds characters to `showtext` at regular intervals and updates the animation.
* **`draw()`**: Draws the content of `showtext`.

#### Note:
When displaying messages during a game, they are displayed one word (or one character for Japanese) at a time.
The display speed can be adjusted with the value of `drawtime`.

```
local msgs = [
  "Micheal: Hello. This is a pen.",
  "Mary: OK. Good bye!",
  "Mario: I love mushrooms!"
]
msg = new GUITextMessage(new Bounds(0, 0, 120, 30),msgs,font,"#FFF")
```

To advance or go back through the messages, use the `goForward()` method in conjunction with key input or button operations.

```
//---For key operation
if keymanager.checkDecide() then
  msg.goForward(1)
end
//---For button operation
btn.callback = function()
  msg.goForward(1)
end
```