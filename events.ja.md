# イベントとコールバック

### `GUISystem`
各種イベントを実行する際のコールバック関数。

* `onresize(w: int, h: int)`: ウィンドウサイズが変更された時に発火する

---
### `GameUI`
各種操作時に任意に実行するコールバック関数をまとめたオブジェクト。`onxxxx` 形式で継承先UIで定義する。

* `onenter(bounds: Bounds)`: UIにマウスカーソルやタップが侵入した
* `onstay(bounds: Bounds)`: マウスカーソルやタップがUIに侵入している
* `onleave(bounds: Bounds)`: マウスカーソルやタップがUIから離れた

---
### `GUIText`
イベント

* `onchange(newtext, oldtext)`: テキストの内容が変更された

---
### `GUICheckbox`
イベント

* `onchange(checked: boolean)`: チェックボックスの状態が変更された

---
### `GUIRadiobutton`
イベント

* `onchange(value: string)`: ラジオボタンの状態が変更された(`checked`が`true`のUIのみイベント発生します。 `value` はUI名です)

---
### `GUIButton`
イベント

* `onpress`: ボタンが押されたときに実行される。
* `onpressing`: ボタンが押されている間実行される。押されている間ずっと発生する。

---
### `GUISlider`
イベント

* `onchange(newval, oldval)`: スライダーの値が変更された

---
### `GUIDialog`
イベント

* `onopen()`: ダイアログが開いた
* `onclose()`: ダイアログが閉じた

---
### `GUIScrollArea`
イベント

* `onscroll(y)`: スクロールした

---
### `GUIListBox`
イベント

* `onchange(newval, oldval)`: 選択時に実行するコールバック関数。`select`メソッド使用時には実行されない。

---
### `UIGridMap`
イベント

* `onhitui(gridx, gridy, ui)`: カーソルがUIにヒットした場合に実行します。（グリッド上のX, Y, UIオブジェクト）
* `onreachedge(dirx, diry)`: カーソルがこれ以上移動できない端に到達した場合に実行します（移動方向X, Y）

---
### `GUITextMessage`
イベント

* `onpageend(pageindex, pagetext)`: 1ページ描画終わった時に実行するコールバック関数。
