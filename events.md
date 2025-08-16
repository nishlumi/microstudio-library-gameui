# Events and Callbacks

### `GUISystem`
Callback functions for executing various events.

* `onresize(w: int, h: int)`: Fired when the window size is changed.

---
### `GameUI`
An object that groups together callback functions to be executed arbitrarily during various operations. Defined in the inherited UI in the `onxxxx` format.

* `onenter(bounds: Bounds)`: The mouse cursor or tap has entered the UI.
* `onstay(bounds: Bounds)`: The mouse cursor or tap is inside the UI.
* `onleave(bounds: Bounds)`: The mouse cursor or tap has left the UI.

---
### `GUIText`
Event

* `onchange(newtext, oldtext)`: The text content has been changed.

---
### `GUICheckbox`
Event

* `onchange(checked: boolean)`: The state of the checkbox has been changed.

---
### `GUIRadiobutton`
Event

* `onchange(value: string)`: The state of the radio button has been changed (event only occurs for UI with `checked` as `true`. `value` is the UI name).

---
### `GUIButton`
Event

* `onpress`: Executed when the button is pressed.
* `onpressing`: Executed while the button is being pressed. Occurs continuously while pressed.

---
### `GUISlider`
Event

* `onchange(newval, oldval)`: The slider value has been changed.

---
### `GUIDialog`
Event

* `onopen()`: The dialog has been opened.
* `onclose()`: The dialog has been closed.

---
### `GUIScrollArea`
Event

* `onscroll(y)`: Scrolled.

---
### `GUIListBox`
Event

* `onchange(newval, oldval)`: Callback function executed upon selection. Not executed when using the `select` method.

---
### `UIGridMap`
Event

* `onhitui(gridx, gridy, ui)`: Executed when the cursor hits a UI. (X, Y on the grid, UI object)
* `onreachedge(dirx, diry)`: Executed when the cursor reaches an edge where it can no longer move. (direction of movement X, Y)

---
### `GUITextMessage`
Event

* `onpageend(pageindex, pagetext)`: Callback function executed when one page has finished drawing.