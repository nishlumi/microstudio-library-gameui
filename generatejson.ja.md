# UIプロパティ一覧（JSON設定用）

このドキュメントは、`GameUIManager.addFromJSON` を使用してUIを生成する際に、各UIコンポーネントがJSONから受け付けるプロパティの一覧です。

## 基本構造

JSONは通常、`controls`というキーを持つオブジェクトの配列で構成されます。

```json
{
  "controls": [
    {
      "uitype": 0,
      "name": "ui_element_name",
      "uigroup": "default",
      // ... 各UIのプロパティ
    },
    {
      // ... another ui element
    }
  ]
}
```

- `uitype`: `TYPELIST`に基づいたUIの種類を示す数値。
- `name`: UIの一意な名前。
- `uigroup`: UIが所属するグループ名。

---

## 共通プロパティ (GameUI)

すべてのUIコンポーネントは `GameUI` を継承しており、以下の共通プロパティを持ちます。

- `name` (String): UIの名前。
- `bounds` (Object): UIの位置とサイズ。 `{ "x": Number, "y": Number, "w": Number, "h": Number }`
- `anchor` (Object): UIのアンカーポイント。 `{ "x": Number, "y": Number }` (-1, 0, 1のいずれか)
- `selectable` (Boolean): ユーザーが選択可能かどうか。
- `focusable` (Boolean): フォーカス可能かどうか。
- `enabled` (Boolean): UIが有効かどうか。
- `rotate` (Number): 回転角度。
- `scale` (Number): スケール（拡大率）。
- `alpha` (Number): 透明度 (0.0 - 1.0)。
- `roundui` (Object): 十字キーなどでUI間を移動する際の隣接UIを名前で指定します。 `{ "up": String, "left": String, "right": String, "bottom": String }`

---

## UI別プロパティ

### TYPELIST.RECT (4) - GUIRect
`GameUI`のプロパティを継承します。
- `color` (String): 矩形の色 (例: `"#FFF"`)。
- `filled` (Boolean): 塗りつぶすかどうか。
- `radius` (Number): 角の丸み。
- `transparencyInterval` (Number): 透明度の変化間隔（現在未使用）。

### TYPELIST.IMAGE (1) - GUIImage
`GameUI`のプロパティを継承します。
- `imagename` (String): 使用するスプライト名。
- `isCutSprite` (Boolean): スプライトを切り出して使用するかどうか。
- `imagerect` (Object): `isCutSprite`がtrueの場合の切り出し範囲。 `{ "x": Number, "y": Number, "w": Number, "h": Number }`

### TYPELIST.TEXT (0) - GUIText
`GameUI`のプロパティを継承します。
- `text` (String): 表示するテキスト。
- `color1` (String): テキストの基本色。
- `color2` (String): テキストの影や縁取りの色。
- `shifted` (Object): `color2`で描画するテキストのオフセット。 `{ "x": Number, "y": Number }`

### TYPELIST.BUTTON (5) - GUIButton
`GameUI`のプロパティを継承し、内部で`GUIText`を持つためそのプロパティも受け付けます。
- `filled` (Boolean): ボタンを塗りつぶすかどうか。
- `radius` (Number): ボタンの角の丸み。
- `bgcolor` (String): 通常時の背景色。
- `pushbgcolor` (String): 押下時の背景色。
- `shadow` (Object): ボタンの影。 `{ "offset": { "x": Number, "y": Number }, "color": String }`
- `text` (GUIText): ボタンのテキスト。
- `color1` (String): テキストの色。

### TYPELIST.CHECKBOX (2) - GUICheckbox
`GameUI`のプロパティを継承し、内部で`GUIText`を持つためそのプロパティも受け付けます。
- `checked` (Boolean): チェックされているかどうか。
- `checkColor` (String): チェックボックスの色。
- `text` (GUIText): ラベルテキスト。
- `color1` (String): ラベルテキストの色。

### TYPELIST.RADIOBUTTON (3) - GUIRadiobutton
`GameUI`のプロパティを継承し、内部で`GUIText`を持つためそのプロパティも受け付けます。
- `checked` (Boolean): 選択されているかどうか。
- `checkColor` (String): ラジオボタンの色。
- `group` (String): ラジオボタンのグループ名。
- `text` (GUIText): ラベルテキスト。
- `color1` (String): ラベルテキストの色。

### TYPELIST.SLIDER (6) - GUISlider
`GameUI`のプロパティを継承します。
- `barcolor` (String): バーの通常時の色。
- `pushbarcolor` (String): バーの操作時の色。
- `curval` (Number): 現在値。
- `minval` (Number): 最小値。
- `maxval` (Number): 最大値。
- `step` (Number): 値の変化量。
- `isVertical` (Boolean): 縦方向のスライダーにするかどうか。
- `label` (Object): 値を表示するラベルの設定。 `{ "enable": Boolean, "size": Number, "x": Number, "y": Number }`

### TYPELIST.CONTAINER (8) - GUIContainer
`GameUI`のプロパティを継承します。
- `color` (String): 背景色。
- `radius` (Number): 角の丸み。
- `contents` (Array): コンテナ内に配置するUIオブジェクトの配列。このドキュメントで定義されている他のUIをネストして含めることができます。

### TYPELIST.DIALOG (7) - GUIDialog
`GUIContainer`のプロパティを継承します。
- `btntype` (Number): 表示するボタンの種類 (`GUIDialog.BTNLIST`の値)。
- `drawtime` (Number): ダイアログが開くときのアニメーション時間（フレーム数）。
- `contents` (Array): ダイアログ内に配置するUIオブジェクトの配列。

### TYPELIST.SCROLLAREA (9) - GUIScrollArea
`GUIContainer`のプロパティを継承します。
- `show_row` (Number): 一列に表示するアイテムの数。
- `item_margin` (Object): アイテム間のマージン。 `{ "x": Number, "y": Number }`
- `contents` (Array): スクロールさせるUIオブジェクトの配列。

### TYPELIST.LISTBOX (10) - GUIListBox
`GUIScrollArea`のプロパティを継承します。
- `pushbgcolor` (String): アイテム押下時の背景色。
- `fontcolor` (String): アイテムのフォント色。
- `selectcolor` (String): 選択されているアイテムの背景色。
- `itemheight` (Number): 各アイテムの高さ。
- `items` (Array<String>): リストボックスに表示する文字列の配列。

### TYPELIST.ANIMATIONIMAGE (11) - GUIAnimationImage
`GameUI`のプロパティを継承します。
- `looptype` (Number): ループの種類 (`GUIAnimationImage.LOOPTYPE`の値)。
- `animationPeriod` (Number): アニメーションの更新間隔（フレーム数）。
- `imagelist` (Array): `GUIImage`のプロパティを持つオブジェクトの配列。

### TYPELIST.ANIMATIONMANAGER (12) - GUIAnimationImageManager
`GameUI`のプロパティを継承します。
- `curMove` (String): 現在再生中のアニメーション名。
- `moveDict` (Object): アニメーションの辞書。キーがアニメーション名、値が`GUIAnimationImage`のプロパティを持つオブジェクト。

### TYPELIST.TEXTMESSAGE (13) - GUITextMessage
`GUIContainer`のプロパティを継承します。
- `color` (String): テキストの色。
- `textforwarding` (Number): テキスト送りタイプ (`FORWARDTYPE.LINE` または `FORWARDTYPE.CHAR`)。
- `messages` (Array<String>): 表示するメッセージの配列。
- `drawtime` (Number): 文字送りや行送りの速度（フレーム数）。
