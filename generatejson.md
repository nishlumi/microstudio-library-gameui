# UI Property List (for JSON configuration)

This document lists the properties that each UI component accepts from JSON when generating a UI using `GameUIManager.addFromJSON`.

## Basic Structure

JSON is typically composed of an array of objects with the key `controls`.

```json
{
  "controls": [
    {
      "uitype": 0,
      "name": "ui_element_name",
      "uigroup": "default",
      // ... properties for each UI
    },
    {
      // ... another ui element
    }
  ]
}
```

- `uitype`: A number indicating the type of UI based on `TYPELIST`.
- `name`: A unique name for the UI.
- `uigroup`: The group name to which the UI belongs.

---

## Common Properties (GameUI)

All UI components inherit from `GameUI` and have the following common properties.

- `name` (String): The name of the UI.
- `bounds` (Object): The position and size of the UI. `{ "x": Number, "y": Number, "w": Number, "h": Number }`
- `anchor` (Object): The anchor point of the UI. `{ "x": Number, "y": Number }` (can be -1, 0, or 1)
- `selectable` (Boolean): Whether the user can select it.
- `focusable` (Boolean): Whether it can be focused.
- `enabled` (Boolean): Whether the UI is enabled.
- `rotate` (Number): Rotation angle.
- `scale` (Number): Scale factor.
- `alpha` (Number): Transparency (0.0 - 1.0).
- `roundui` (Object): Specifies adjacent UIs by name for navigation with D-pad, etc. `{ "up": String, "left": String, "right": String, "bottom": String }`

---

## Properties by UI Type

### TYPELIST.RECT (4) - GUIRect
Inherits properties from `GameUI`.
- `color` (String): Color of the rectangle (e.g., `"#FFF"`).
- `filled` (Boolean): Whether to fill the rectangle.
- `radius` (Number): Corner radius.
- `transparencyInterval` (Number): Interval for transparency change (currently unused).

### TYPELIST.IMAGE (1) - GUIImage
Inherits properties from `GameUI`.
- `imagename` (String): Name of the sprite to use.
- `isCutSprite` (Boolean): Whether to use a cutout from a sprite sheet.
- `imagerect` (Object): The cutout area if `isCutSprite` is true. `{ "x": Number, "y": Number, "w": Number, "h": Number }`

### TYPELIST.TEXT (0) - GUIText
Inherits properties from `GameUI`.
- `text` (String): Text to display.
- `color1` (String): Primary color of the text.
- `color2` (String): Shadow or outline color of the text.
- `shifted` (Object): Offset for the text drawn with `color2`. `{ "x": Number, "y": Number }`

### TYPELIST.BUTTON (5) - GUIButton
Inherits properties from `GameUI` and also accepts properties from `GUIText` as it contains one internally.
- `filled` (Boolean): Whether to fill the button.
- `radius` (Number): Corner radius of the button.
- `bgcolor` (String): Background color in normal state.
- `pushbgcolor` (String): Background color when pressed.
- `shadow` (Object): Shadow of the button. `{ "offset": { "x": Number, "y": Number }, "color": String }`
- `text` (GUIText): The button's text.
- `color1` (String): Text color.

### TYPELIST.CHECKBOX (2) - GUICheckbox
Inherits properties from `GameUI` and also accepts properties from `GUIText` as it contains one internally.
- `checked` (Boolean): Whether it is checked.
- `checkColor` (String): Color of the checkbox.
- `text` (GUIText): Label text.
- `color1` (String): Label text color.

### TYPELIST.RADIOBUTTON (3) - GUIRadiobutton
Inherits properties from `GameUI` and also accepts properties from `GUIText` as it contains one internally.
- `checked` (Boolean): Whether it is selected.
- `checkColor` (String): Color of the radio button.
- `group` (String): Group name for the radio button.
- `text` (GUIText): Label text.
- `color1` (String): Label text color.

### TYPELIST.SLIDER (6) - GUISlider
Inherits properties from `GameUI`.
- `barcolor` (String): Color of the bar in normal state.
- `pushbarcolor` (String): Color of the bar when being manipulated.
- `curval` (Number): Current value.
- `minval` (Number): Minimum value.
- `maxval` (Number): Maximum value.
- `step` (Number): Step value for changes.
- `isVertical` (Boolean): Whether to make it a vertical slider.
- `label` (Object): Settings for the label that displays the value. `{ "enable": Boolean, "size": Number, "x": Number, "y": Number }`

### TYPELIST.CONTAINER (8) - GUIContainer
Inherits properties from `GameUI`.
- `color` (String): Background color.
- `radius` (Number): Corner radius.
- `contents` (Array): Array of UI objects to place inside the container. Can contain other UIs defined in this document.

### TYPELIST.DIALOG (7) - GUIDialog
Inherits properties from `GUIContainer`.
- `btntype` (Number): Type of buttons to display (value from `GUIDialog.BTNLIST`).
- `drawtime` (Number): Animation time for the dialog to open (in frames).
- `contents` (Array): Array of UI objects to place inside the dialog.

### TYPELIST.SCROLLAREA (9) - GUIScrollArea
Inherits properties from `GUIContainer`.
- `show_row` (Number): Number of items to display in a row.
- `item_margin` (Object): Margin between items. `{ "x": Number, "y": Number }`
- `contents` (Array): Array of UI objects to scroll.

### TYPELIST.LISTBOX (10) - GUIListBox
Inherits properties from `GUIScrollArea`.
- `pushbgcolor` (String): Background color of an item when pressed.
- `fontcolor` (String): Font color of the items.
- `selectcolor` (String): Background color of the selected item.
- `itemheight` (Number): Height of each item.
- `items` (Array<String>): Array of strings to display in the listbox.

### TYPELIST.ANIMATIONIMAGE (11) - GUIAnimationImage
Inherits properties from `GameUI`.
- `looptype` (Number): Type of loop (value from `GUIAnimationImage.LOOPTYPE`).
- `animationPeriod` (Number): Animation update interval (in frames).
- `imagelist` (Array): Array of objects with `GUIImage` properties.

### TYPELIST.ANIMATIONMANAGER (12) - GUIAnimationImageManager
Inherits properties from `GameUI`.
- `curMove` (String): Name of the currently playing animation.
- `moveDict` (Object): Dictionary of animations. The key is the animation name, and the value is an object with `GUIAnimationImage` properties.

### TYPELIST.TEXTMESSAGE (13) - GUITextMessage
Inherits properties from `GUIContainer`.
- `color` (String): Text color.
- `textforwarding` (Number): Text forwarding type (`FORWARDTYPE.LINE` or `FORWARDTYPE.CHAR`).
- `messages` (Array<String>): Array of messages to display.
- `drawtime` (Number): Speed of text/line forwarding (in frames).
