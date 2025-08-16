# リファレンス

## 各クラス

### グローバル関数

**`drawSpritePartBounds = function(imagename, srcbnd, destbnd)`**: `screen.drawSpritePart`の`Bounds`版です。画像の指定された部分を指定された矩形領域に描画します。




### `Object` 拡張

#### メソッド

*   **`include = function (name)`**: 指定された`name`がオブジェクト内に存在するかどうかを確認します。存在する場合は`true`を、それ以外の場合は`false`を返します。Pythonの`in`演算子に似ています。
*   **`exclude = function (name)`**: 指定された`name`がオブジェクト内に存在しないかどうかを確認します。存在しない場合は`true`を、それ以外の場合は`false`を返します。
*   **`getKey = function (val)`**: オブジェクト内で指定された`val`に対応するキーを検索し、最初に見つかったキーを返します。見つからない場合は空文字列を返します。
*   **`getKeys = function()`**: オブジェクトのすべてのキーをリストとして返します。

### `List` 拡張

#### メソッド

*   **`clear = function()`**: リストからすべての要素を削除し、空にします。

### `Number` 拡張

#### メソッド

*   **`checkRange = function (minval, maxval)`**: 数値が`minval`と`maxval`の指定された範囲内にあるかどうかを確認します。範囲内にある場合は`true`を、それ以外の場合は`false`を返します。

---

### `multiTextSplitter`
テキストの折り返し機能を提供するグローバル関数です。特に日本語と英語の文字幅を考慮して設計されています。

#### プロパティ

* **`charWidth`**: 全角文字の幅（ピクセル単位）。半角文字はその半分の幅として扱われます。
* **`charHeight`**: 1行の高さ（現在のロジックでは使用されていません）。

#### メソッド

* **`isJapaneseChar(char)`**: 与えられた文字が全角の日本語文字（漢字、ひらがな、カタカナ、または特定の記号）であるかを判断します。
* **`calcTextWidth(text)`**: テキストの表示幅を計算します。全角文字は`charWidth`、その他の文字は`charWidth / 2`として計算されます。
* **`splitText(text)`**: テキストを単語または文字単位に分割します。日本語文字、全角数字、全角英数字、半角英数字の単語、句読点、スペースなどで分割されます。
* **`wrapText(text, maxWidth)`**: 指定された最大幅に基づいてテキストを折り返します。

---

### `Bounds`

#### プロパティ

* **`x`**: 矩形のX座標。
* **`y`**: 矩形のY座標。
* **`w`**: 矩形の幅（width）。
* **`h`**: 矩形の高さ（height）。

#### メソッド

* **`constructor = function (x, y = 0, w = 0, h = 0)`**: 矩形領域の新しいインスタンスを作成します。引数がオブジェクトの場合、そのプロパティをコピーします。
* **`zero = function()`**: Boundsのプロパティ全てが0のインスタンスを返します。インスタンス化していなくても使えます。

---

### `GUIFPS`

フレームレートに基づいて時間の進行を管理するクラスです。

#### プロパティ

*   **`framedur`**: 1フレームの持続時間（ミリ秒）。
*   **`lasttime`**: 最後の更新のシステム時刻。
*   **`now`**: 現在のシステム時刻。

#### メソッド

*   **`constructor()`**: `GUIFPS`インスタンスを初期化します。
*   **`each(val)`**: `val`フレームが経過したかどうかを確認します。経過した場合は`true`を返し`lasttime`を更新し、それ以外の場合は`false`を返します。
*   **`update()`**: `now`プロパティを現在のシステム時刻で更新します。

---

### `GUISystem`
UIシステムの基本的な設定と座標変換、時間管理（`GUIFPS`を通じて）を行うクラスです。

#### プロパティ

* **`left`**: スクリーン座標の左端。
* **`right`**: スクリーン座標の右端。
* **`top`**: スクリーン座標の上端。
* **`bottom`**: スクリーン座標の下端。
* **`oldscreen`**: スクリーンの幅と高さのバックアップ。
* **`unit`**: グリッド計算に使用される単位（ピクセル数）。
* **`unitRange`**: スクリーン全体のグリッドの範囲情報。
  - **`minx`**: グリッドの最小値（x）
  - **`miny`**: グリッドの最小値（y）
  - **`maxx`**: グリッドの最大値（x）
  - **`maxy`**: グリッドの最大値（y）
  - **`countx`**: グリッドの個数（x）
  - **`county`**: グリッドの個数（y）
* **`fps`**: `GUIFPS` クラスのインスタンス。時間管理に使用されます。
* **`fonts`**: `GameFont` クラスの配列。
* **`uimanager`**: `GameUIManager` クラスのインスタンス。
* **`keymanager`**: `KeyManager` クラスのインスタンス。
* **`callback`**: 各種イベントを実行する際のコールバック関数。
  - **`onresize(w: int, h: int)`**: ウィンドウサイズが変更された時に発火する

#### メソッド

* **`constructor()`**: `GUISystem` のインスタンスを初期化し、スクリーンサイズに基づいた座標、グリッド、単位を設定し、`GUIFPS` のインスタンスを作成します。
* **`setUnit(unit: Number)`**: 新しい単位のunitを設定します。
* **`pos(num: Number)`**: 指定されたグリッド単位の数値をピクセル座標に変換して返します。
* **`addFont(name,size)`**: 使用したいフォントを追加します。
* **`update()`**: `fps` プロパティの `update` メソッドを呼び出し、内部の時間管理を更新します。また、スクリーンのサイズを `oldscreen` に保存します。KeyManager.updateからの戻り値を取得してさらに返します。
* **`uiupdate(grp = "default")`**: GameUIManagerの指定のグループのUIを更新します。
* **`uidraw(grp = "default")`**: GameUIManagerの指定のグループのUIを描画します。




---

### `GameFont`

ゲームで使用するフォントの情報を保持するクラスです。

#### プロパティ

* **`name`**: フォントの名前。
* **`size`**: フォントのサイズ。

#### メソッド

* **`constructor(name, size)`**: フォントの新しいインスタンスを作成し、名前とサイズを設定します。

**Note**:  
* 標準フォントは `name` は未入力でかまいません。
* 標準以外のフォントはAssetsで必要に応じて読み込んでおいてください。

---

### `KeyElement`

単一のキー操作（どのデバイスの、どのキーの、どのアクションか）を定義します。


#### プロパティ

* **`ctrlname`**: コントローラーの種類（`"k"`はキーボード、`"g"`はゲームパッド）。
* **`keyname`**: キーの名前。
* **`action`**: キーアクション（`"d"`は押されている、`"p"`は押された瞬間、`"r"`は離された瞬間）。

#### メソッド

* **`constructor(ctrler, keyname, action)`**: `KeyElement` の新しいインスタンスを作成し、コントローラー名、キー名、アクションを設定します。

---

### `KeyManager`
キーボードとゲームパッドの入力を管理し、決定、キャンセル、方向、およびカスタムキーの状態をチェックするクラスです。
複数の `KeyElement` を束ねて、特定の操作（決定、キャンセル、移動など）として管理します。


#### プロパティ

* **`key_decide`**: 決定キーのリスト（例: Enterキー）。
* **`key_cancel`**: キャンセルキーのリスト（例: Escapeキー）。
* **`key_up`**: 上方向キーのリスト（例: UPキー、Wキー、DPAD_UP）。
* **`key_down`**: 下方向キーのリスト（例: DOWNキー、Sキー、DPAD_DOWN）。
* **`key_left`**: 左方向キーのリスト（例: LEFTキー、Aキー、DPAD_LEFT）。
* **`key_right`**: 右方向キーのリスト（例: RIGHTキー、Dキー、DPAD_RIGHT）。
* **`key_custom`**: カスタムキーのリストを格納するオブジェクト（キー名と`KeyElement`のリストのペア）。

#### メソッド

* **`constructor(parent: GUISystem)`**: `KeyManager` のインスタンスを初期化し、標準のキーリストとカスタムキー用のオブジェクトを設定します。
* **`_checkBody(key, action = "")`**: 指定された`KeyElement`とアクションに基づいて、キーが押されているか (`"d"`)、押された瞬間か (`"p"`)、離された瞬間か (`"r"`) をチェックします。キーボードとゲームパッドの両方に対応しています。
* **`_keyBody(lst, action = "")`**: `KeyElement`のリストを反復処理し、いずれかのキーが指定されたアクション（またはキーに設定されたデフォルトアクション）を満たしているかをチェックします。
* **`addCustomKey(name, lst)`**: カスタムキーのリストを`name`に関連付けて追加します。
* **`removeCustomKey(name)`**: 指定された`name`のカスタムキーリストを削除します。
* **`is_up(action = "")`**: 上方向キーが指定されたアクション（デフォルトは押された瞬間 `"p"`）を満たしているかをチェックします。
* **`is_down(action = "")`**: 下方向キーが指定されたアクションを満たしているかをチェックします。
* **`is_left(action = "")`**: 左方向キーが指定されたアクションを満たしているかをチェックします。
* **`is_right(action = "")`**: 右方向キーが指定されたアクションを満たしているかをチェックします。
* **`checkDecide(action = "")`**: 決定キーが指定されたアクションを満たしているかをチェックします。
* **`checkCancel(action = "")`**: キャンセルキーが指定されたアクションを満たしているかをチェックします。
* **`checkCustom(name, action = "")`**: 指定された`name`のカスタムキーが指定されたアクションを満たしているかをチェックします。
* **`update()`**: キー操作を更新します。 `{x : [X軸の方向（-1～1）], y: [Y軸の方向（-1～1）] }` が返ってきます。


#### Note:  
``GUISystem`` をインスタンス化すれば、プロパティとして含んでいるので、基本的には個別に用意することはないと思います。

標準では決定やキャンセル、上下左右への移動の操作が定義されています。入力キーを追加する場合は`KeyElement`クラスを使い、`key_decide`などに追加してください。

標準以外のゲームの操作については、 `key_custom`に操作名と`KeyElement`のリストを登録することで拡張できます。

方向はis_upなどで真偽値で取得できます。方向を-1～1の数値で取得したい場合、updateを呼び出してその戻り値を参照してください。

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
UI要素のタイプを定義するオブジェクトです。数値で各UIタイプが割り当てられています。

| UIタイプ         | 値 |
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
ゲーム全体のUI要素をグループ単位で管理するクラスです。

#### プロパティ

* **`ui`**: UI要素をグループ別に格納するオブジェクト（例: `ui.default.element`）。

#### メソッド

* **`constructor(parent: GUISystem)`**: `this.ui`オブジェクトを初期化し、`default`グループを作成します。
* **`loadFromJSON(data)`**: JSONデータから各UIを生成します。生成したUIのListを返します。これはUIを生成するだけです。
* **`addFromJSON(data)`**: JSONデータから各UIを生成し、指定のUIグループへの追加も行いまs。
* **`getGroupCount()`**: 管理しているUIグループの数を返します。
* **`getCount(group = "default")`**: 指定されたグループ内のUI要素の数を返します。
* **`g(group)`**: 指定したグループのObjectを取得します。
* **`getObject(name, group = "default")`**: 指定されたグループから、指定された名前のUI要素を取得します。コンテナやスクロールエリア内の要素も検索します。
* **`add(ui, group = "default", name = "")`**: UI要素を指定されたグループに追加します。UI要素の`uigroup`と`referlist`プロパティも設定します。
* **`addGroup(group)`**: 新しいUIグループを追加します。
* **`rename(name, newname, group = "default")`**: 指定されたグループ内でUI要素の名前を変更します。
* **`remove(name, group = "default")`**: 指定されたグループから、指定された名前のUI要素を削除します。
* **`removeGroup(group)`**: 指定されたグループを削除します。`default`グループは削除できません。
* **`getGroupItems(grpname)`**: 指定されたグループ名に属するすべてのUI要素をリストとして返します。
* **`update(group)`**: 指定されたグループ内のすべてのUI要素を更新します。
* **`draw(group)`**: 指定されたグループ内のすべてのUI要素を描画します。`DIALOG`タイプのUIは他の要素より優先して描画されます。

#### Note: 
  ``GameUIManager`` はゲーム中に1個だけグローバルで作り、ゲームシーンごとにグループを追加します。
  そして各UI要素はグループを指定して追加・削除していきます。
  
  ``GUISystem`` をインスタンス化すれば、プロパティとして含んでいるので、基本的には個別に用意することはないと思います。
  
  ``update()`` と ``draw()`` はグループを指定して呼び出します。（そうしないと常に全てのシーンのUIが更新されてしまいます。）
  ``GUISystem`` にある ``uiupdate`` 、 ``uidraw`` を呼び出しても同じです。

---

### `GameUI`
すべてのUI要素の基底クラスです。

#### プロパティ

* **`isOpenWindow`**: 現在ウィンドウが開いているかどうかを示すブール値です。
* **`name`**: UI要素のユニークな識別子。
* **`referlist`**: このUI要素が属するUIグループの参照。
* **`bounds`**: UI要素の位置とサイズ（x, y, w, h）。
* **`tmpbnds`**: `bounds`のコピー。
* **`endx`**: `bounds.x + bounds.w` の値。
* **`endy`**: `bounds.y - bounds.h` の値。
* **`anchorx`**: アンカーポイントのX座標。
* **`anchory`**: アンカーポイントのY座標。
* **`uitype`**: UI要素のタイプ（`TYPELIST`の値）。
* **`roundui`**: 周囲のUI要素を参照するためのオブジェクト（将来の拡張用）。
* **`selectable`**: UIが選択可能かどうかのブール値。
* **`focusable`**: UIがフォーカス可能かどうかのブール値。
* **`enabled`**: UIが有効かどうかを示すブール値。
* **`parent`**: `GameUIManager`への参照。
* **`keyman`**: `KeyManager`への参照。
* **`rotate`**: UI要素の回転角度。
* **`scale`**: UI要素のスケール。
* **`alpha`**: UI要素の透明度。
* **`uigroup`**: このUI要素が属するグループの名前。
* **`tmpparam`**: 自由に使用できるパラメータ領域。
* **`fps`**: `GUIFPS` のインスタンス。このUI要素の時間管理に使用されます。
* **`font`**: UI内で使用する`GameFont`。
* **`callback`**: 各種操作時に任意に実行するコールバック関数をまとめたオブジェクト。`onxxxx` 形式で継承先UIで定義する。
  - **`onenter(bounds: Bounds)`**: UIにマウスカーソルやタップが侵入した
  - **`onstay(bounds: Bounds)`**: マウスカーソルやタップがUIに侵入している
  - **`onleave(bounds: Bounds)`**: マウスカーソルやタップがUIから離れた
* **`old`**: 古いステータスを保持するオブジェクト(これ以外にも継承先で定義されたり、自由に使えます)
  - **`touched`**: タッチしていたか
  - **`entered`**: マウスやタッチがUIに入っていたか

#### メソッド

* **`constructor(uitype, bounds: Bounds, rotate = 0, scale = 1)`**: UI要素の基本的なプロパティを初期化します。
* **`loadJSON(data)`**: JSONデータからUIのプロパティを設定します。
* **`getObject(name)`**: `referlist`または`SCROLLAREA`/`CONTAINER`の`contents`から指定された名前のUI要素を取得します。
* **`setDirectRound(label, ui)`**: `roundui`オブジェクトに直接UI要素を設定します。
* **`setRound(upui = null, leftui = null, rightui = null, bottomui = null)`**: 上下左右のUI要素を設定し、文字列で渡された場合は`getObject`を使用して解決します。
* **`setPos(x,y)`**: UI要素の位置を設定します。
* **`calcPosByAnchor(ax, ay)`**: アンカーポイントに基づいて位置を計算します。
* **`setAnchor(x, y)`**: アンカーポイントを設定します。
* **`setSize(w, h)`**: UI要素のサイズを設定します。
* **`checkTouchArea(x, y)`**: 指定された座標がUI要素のタッチ領域内にあるかチェックします。
* **`update()`**: UI要素の状態を更新します（`this.fps.update()`を呼び出します）。
* **`draw()`**: UI要素を描画する準備をします（アンカー、スケール、回転、アルファを設定）。具体的な描画は子クラスで行われます。

#### Note:  
  後述の ``UIGridMap`` を使うことで、キーボードやゲームパッドでUI間をカーソル移動させることができます。  
  そのためには ``roundui`` にカーソルの移動先のUIの参照をセットしてください。  
  ``UIGridMap``だけを使うよりもさらに細かいカーソルの制御を行うことができます。
  
---

### `GUIImage`
画像を表示するためのUI要素クラスです。

#### プロパティ

* **`imagename`**: 表示する画像の名前。
* **`img_bnd`**: 画像の一部を表示する場合の矩形領域。
* **`isCutSprite`**: 画像の一部を切り出すかどうかを示すブール値。

#### メソッド

* **`constructor(bnd: Bounds, imagename, imagerect = 0, rotate = 0, scale = 1.0)`**: 画像名、表示する画像の矩形領域(`imagerect`)、位置、サイズなどを設定します。`imagerect`が指定された場合、スプライトの一部を切り出して表示します。
* **`setImage(newimg)`**: 表示する画像を新しい画像に設定します。
* **`update()`**: 親クラスの`update`メソッドを呼び出します。
* **`draw()`**: 画像を描画します。`isCutSprite`が`true`の場合は`drawSpritePartBounds`を、そうでない場合は`screen.drawSprite`を使用します。

---

### `GUIAnimationImage`
アニメーション画像を管理・表示するUI要素クラスです。

#### プロパティ

* **`LOOPTYPE`**: アニメーションのループタイプを定義するオブジェクト（`TOBEGIN`, `NOLOOP`, `REVERSE`）。
* **`imagelist`**: `GUIImage`オブジェクトのリスト。アニメーションの各フレームを表します。
* **`isManualAnimation`**: アニメーションが手動で制御されているかどうかを示すブール値（`true`なら再生中）。
* **`curImage`**: 現在表示されている画像のインデックス。
* **`looptype`**: アニメーションのループ方法（`LOOPTYPE`の値）。
* **`loopv`**: アニメーションの再生方向（1: 順方向, -1: 逆方向）。
* **`animationPeriod`**: アニメーションの各フレームが表示される期間（フレーム数）。

#### メソッド

* **`constructor(bnd)`**: `GUIAnimationImage`のインスタンスを初期化し、アニメーションのフレームリストやループ設定などを設定します。
* **`loadJSON(data)`**: JSONオブジェクトからプロパティを読み込みます。
* **`addImage(img)`**: アニメーションに`GUIImage`を追加します。追加される画像のバウンズはアニメーションイメージ自身のバウンズに合わせられます。
* **`removeImage(index)`**: 指定されたインデックスの画像をアニメーションから削除します。
* **`play()`**: アニメーションを最初から再生します。
* **`stop()`**: アニメーションの再生を停止します。
* **`playToggle()`**: アニメーションの再生/一時停止を切り替えます。
* **`update()`**: アニメーションが再生中の場合、設定された期間に基づいて次のフレームに進みます。ループタイプに応じて再生方向やインデックスを調整します。
* **`draw()`**: 現在表示されているアニメーションフレームの画像を描画します。

---

### `GUIAnimationImageManager`
複数のアニメーション画像を管理し、現在表示するアニメーションを切り替えるクラスです。

#### プロパティ

* **`moveDict`**: アニメーション画像（`GUIAnimationImage`）を名前で管理するオブジェクト。
* **`curMove`**: 現在表示されているアニメーションの名前。

#### メソッド

* **`constructor(bnd: Bounds)`**: `GUIAnimationImageManager`のインスタンスを初期化し、アニメーション辞書と現在の動きを設定します。
* **`cur(name)`**: 指定された名前のアニメーション画像を返します。
* **`setCur(name)`**: 現在表示するアニメーションを指定された名前に設定します。
* **`addAnimation(name)`**: 新しいアニメーション画像を作成し、指定された名前で管理リストに追加します。
* **`removeAnimation(name)`**: 指定された名前のアニメーション画像を管理リストから削除します。
* **`update()`**: 現在表示されているアニメーション画像の`update`メソッドを呼び出します。
* **`draw()`**: 現在表示されているアニメーション画像の`draw`メソッドを呼び出します。

#### Note:  
`GUIAnimationImage` と `GUIAnimationImageManager` を使うことでより様々なアニメーションをまとめて制御できます。
使用のイメージはこのような流れです。

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

`GUIAnimationImageManager` は `GUIAnimationImage` を複数管理できます。アニメーション名を `addAnimation` に指定することで、内部で`GUIAnimationImage` を生成して保持します。

その `GUIAnimationImage` は `GUIImage`を複数管理し、1つのアニメーションを構築できます。  
(Spritesパネルでアニメーションを作っている場合、`GUIImage`　は1つで済むかもしれません)

実際にゲームで使用する際は、 `GUIAnimationImageManager.curMove` にアニメーション名をセットすることで、随時アニメーションを切り替えることができます。

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

- コードのサンプルは `example.ms` の GUIAnimationImageManager & GUIImage をご覧ください。

---

### `GUIText`
テキストを表示するためのUI要素クラスです。

#### プロパティ

* **`wrapper`**: `multiTextSplitter`を使用してテキストの折り返しを処理するオブジェクト。
* **`is_wrap`**: テキストを折り返すかどうかを示すブール値。
* **`realtexts`**: 折り返し処理後のテキスト行を格納するリスト。
* **`text`**: 表示するテキストの内容。
* **`color1`**: テキストのメインカラー。
* **`color2`**: テキストのシャドウカラー。
* **`shifted`**: シャドウのオフセット（x, y）。
* **`font`**: 使用するフォントのオブジェクト。
* **`blink_time`**: 点滅時間（現在のコードでは直接使用されていません）。
* **`callback`**: イベント
  - **`onchange(newtext, oldtext)`**: テキストの内容が変更された

#### メソッド

* **`constructor(text, bnd: Bounds, font = 0, color1 = 0, color2 = 0,shifted_x = 0, shifted_y = 0)`**: テキスト内容、バウンズ、フォント、色などを設定します。
* **`loadJSON(data)`**: JSONオブジェクトからプロパティを読み込みます。
* **`setText(txt)`**: テキストを設定し、必要に応じて折り返しを再計算します。
* **`recalcWrap()`**: テキストの折り返しを再計算します。
* **`refreshText(width)`**: 幅に基づいてテキストの折り返しを再計算します。
* **`update()`**: 親クラスの`update`メソッドを呼び出します。
* **`draw()`**: テキストを描画します。`shifted`プロパティに基づいてシャドウのような効果も描画できます。

#### Note:  
`GUIText`は折り返しを制御するため、別ライブラリ `multiTextSplitter` を内蔵しています。

その他、フォントを変えたり、shifted_x, shifted_y を指定することで影をずらして描画することもできます。


---

### `GUICheckbox`
チェック状態を持つUI要素クラスです。

#### プロパティ

* **`pressed`**: チェックボックスが押されているかどうかを示すブール値。
* **`checked`**: チェックされているかどうかを示すブール値。
* **`text`**: チェックボックスのラベルとして使用される`GUIText`インスタンス。
* **`checkColor`**: チェックボックスの色。
* **`callback`**: イベント
  - **`onchange(checked: boolean)`**: チェックボックスの状態が変更された

#### メソッド

* **`constructor(text, bnd: Bounds, chked = 0, font = 0, color1 = 0, color2 = 0,shifted_x = 0, shifted_y = 0)`**: テキスト、バウンズ、初期チェック状態、フォント、色などを設定します。
* **`loadJSON(data)`**: JSONオブジェクトからプロパティを読み込みます。
* **`setFont(font: GameFont)`**: テキストラベル用にフォントをセットします。
* **`checkTouchArea(x, y)`**: チェックボックスの本体とテキストの両方を含むタッチ領域をチェックします。
* **`check()`**: チェック状態を反転させます。
* **`uncheck()`**: チェック状態を`false`にします。
* **`update()`**: マウスまたはタッチがリリースされたときに、チェックボックスの状態を切り替えます。
* **`draw()`**: チェック状態に応じて四角形を塗りつぶすか枠線を描画し、ラベルテキストも描画します。

#### Note:  
チェック状態の取得には`checked` を参照してください。

---

### `GUIRadiobutton`
グループ内で1つだけ選択可能なUI要素クラスです。

#### プロパティ

* **`pressed`**: ラジオボタンが押されているかどうかを示すブール値。
* **`checked`**: チェックされているかどうかを示すブール値。
* **`text`**: ラジオボタンのラベルとして使用される`GUIText`インスタンス。
* **`checkColor`**: ラジオボタンの色。
* **`group`**: ラジオボタンが属するグループ名。
* **`callback`**: イベント
  - **`onchange(value: string)`**: ラジオボタンの状態が変更された(`checked`が`true`のUIのみイベント発生します。 `value` はUI名です)

#### メソッド

* **`constructor(text, grpname, bnd: Bounds, chked = 0, font = 0, color1 = 0, color2 = 0,shifted_x = 0, shifted_y = 0)`**: テキスト、グループ名、バウンズなどを設定します。
* **`loadJSON(data)`**: JSONオブジェクトからプロパティを読み込みます。
* **`setFont(font: GameFont)`**: テキストラベル用にフォントをセットします。
* **`checkTouchArea(x, y)`**: ラジオボタンの本体とテキストの両方を含むタッチ領域をチェックします。
* **`check()`**: このラジオボタンをチェックし、同じグループ内の他のラジオボタンのチェックを外します。
* **`uncheck()`**: チェック状態を`false`にします。
* **`getGroupValue()`**: ラジオボタンのグループの中でtrueになっているUIの`name`を返す
* **`update()`**: マウスまたはタッチがリリースされたときに、ラジオボタンの状態を切り替えます。同じグループ内の他のラジオボタンのチェック状態も管理します。
* **`draw()`**: チェック状態に応じて円を塗りつぶすか枠線を描画し、ラベルテキストも描画します。

#### Note:  
* groupを指定することで、択一になります。
* チェック状態の取得には`checked` を参照してください。
* ラジオボタンのアイテム間のカーソルの移動は、`UIGridMap` か 各UI要素の`roundui`をセットして使ってください。


---

### `GUIRect`
単純な矩形を描画するためのUI要素クラスです。

#### プロパティ

* **`color`**: 矩形の色。
* **`filled`**: 矩形を塗りつぶすかどうかを示すブール値。
* **`radius`**: 矩形の角の丸み。
* **`transparency`**: 矩形の透明度。
* **`transparencyInterval`**: 透明度の変化間隔。

#### メソッド

* **`constructor(bnd: Bounds, color, filled = true, radius = 0, transparency = 1, transparency_interval = 0)`**: バウンズ、色、塗りつぶし有無、角の丸み、透明度などを設定します。
* **`loadJSON(data)`**: JSONオブジェクトからプロパティを読み込みます。
* **`update()`**: 親クラスの`update`メソッドを呼び出します。
* **`draw()`**: 設定に基づいて矩形（角丸矩形含む）を塗りつぶすか枠線を描画します。

---

### `GUIButton`
クリック可能なボタンのUI要素クラスです。

#### プロパティ

* **`pressed`**: ボタンが押されているかどうかを示すブール値。
* **`filled`**: ボタンの背景を塗りつぶすかどうかを示すブール値。
* **`radius`**: ボタンの角の丸み。
* **`text`**: ボタンのラベルとして使用される`GUIText`インスタンス。
* **`bgcolor`**: ボタンの背景色。
* **`pushbgcolor`**: ボタンが押された時の背景色。
* **`curBgcolor`**: 現在の背景色。
* **`callback`**: イベント
  - **`onpress`**: ボタンが押されたときに実行される。
  - **`onpressing`**: ボタンが押されている間実行される。押されている間ずっと発生する。
* **`shadow`**: ボタンの影に関する設定（オフセット、色）。

#### メソッド

* **`constructor(text, bnd, font = 0, bgcolor = "#FF0", pushbgcolor = "#CC0", fontcolor = "#000", filled = true, radius = 0, callback = 0)`**: テキスト、バウンズ、フォント、背景色、押下時の背景色、フォント色、塗りつぶし有無、角の丸み、コールバック関数などを設定します。
* **`loadJSON(data)`**: JSONオブジェクトからプロパティを読み込みます。
* **`setFont(font: GameFont)`**: テキストラベル用にフォントをセットします。* **`checkTouchArea(x, y)`**: ラジオボタンの本体とテキストの両方を含むタッチ領域をチェックします。
* **`push()`**: ボタンのコールバックを手動でトリガーします。
* **`update()`**: マウスまたはタッチがリリースされたときに、ボタンの状態を更新し、押された場合はコールバックを実行します。
* **`draw()`**: ボタンの影と本体を描画し、テキストも描画します。

#### Note:  
ボタンを押したときのイベントは `callback`に `function end` を指定すれば任意の処理を簡単に実行できます。

`pressed` を手動で判定すれば独自のイベントを実行することもできるでしょう。また、 `push` メソッドでコールバック関数を任意のタイミングで呼び出すことも出来ます。

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
値を調整するためのスライダーUI要素クラスです。

#### プロパティ

* **`pressed`**: スライダーのバーが現在押されているかどうかを示すブール値。
* **`presspos`**: バーが押された際のマウス/タッチの座標。
* **`barcolor`**: スライダーのバーの通常時の色。
* **`pushbarcolor`**: スライダーのバーが押されている時の色。
* **`curBarcolor`**: 現在のバーの色（`barcolor`または`pushbarcolor`）。
* **`bgcolor`**: スライダーのメーターの背景色。
* **`minvalue`**: スライダーが取りうる最小値。
* **`maxvalue`**: スライダーが取りうる最大値。
* **`step`**: スライダーの値を調整する際のステップ量。
* **`value`**: スライダーの現在の値。
* **`old.value`**: 古い値。
* **`isVertical`**: スライダーが縦型かどうかを示すブール値（`true`なら縦型、`false`なら横型）。
* **`label`**: スライダーの現在の値を表示するラベルに関する設定（`enable`有効/無効、`size`サイズ、`x`/`y`位置、`color`色）。
* **`barbnd`**: スライダーのバーの位置とサイズを示す`Bounds`オブジェクト。
* **`real_x`**: スライダーの内部計算に使用されるX座標（縦型の場合はY座標）。
* **`callback`**: イベント
  - **`onchange(newval, oldval)`**: スライダーの値が変更された

#### メソッド

* **`constructor(bnd: Bounds, defaultval, minval, maxval, step, isVertical = false, bgcolor = "#999", barcolor = "#EEE", pushbarcolor = "#FFF")`**: スライダーのインスタンスを初期化し、バウンズ、デフォルト値、最小値、最大値、ステップ、向き、色などを設定します。
* **`loadJSON(data)`**: JSONオブジェクトからプロパティを読み込みます。
* **`setValue(val)`**: スライダーの値を`val`だけ増減させ、`minval`と`maxval`の範囲内に制限します。
* **`calclateBarPosition(x, y)`**: マウス/タッチ座標に基づいてスライダーのバーの位置と、それに対応する`curval`を計算します。
* **`update()`**: マウスまたはタッチ入力に基づいてスライダーのバーの状態（押下状態、色、値）を更新します。
* **`draw()`**: スライダーのメーター（背景）とバーを描画します。`isVertical`プロパティに応じて縦または横のスライダーとして描画され、ラベルも表示されます。

#### Note:  
デフォルトではランドスケープのスライダーですが、生成時に引数`isVertical`をtrueにすると、ポートレートのスライダーになります。  
それぞれその向きになるように、生成時に`bnd`に指定するBoundsの`w`と`h`を設定してください。

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
ポップアップ表示されるダイアログウィンドウのUI要素クラスです。

#### プロパティ

* **`BTNLIST`**: ダイアログに表示されるボタンの種類を定義するオブジェクト（OK, YESNO, YESNOCANCEL, CUSTOM）。
* **`color`**: ダイアログの背景色。
* **`contents`**: ダイアログ内に表示されるUI要素のリスト。
* **`font`**: ダイアログ内で使用されるフォント。
* **`buttons`**: ダイアログのボタンのリスト。
* **`btntype`**: ダイアログに表示するボタンの種類（`BTNLIST`の値）。
* **`drawtime`**: ダイアログが開くアニメーションのフレーム数。
* **`drawpart`**: ダイアログの描画アニメーションにおける各フレームでの増分（x, y）。
* **`curdraw`**: 現在の描画アニメーションのフレーム数。
* **`is_startdraw`**: ダイアログの描画アニメーションが開始されたかどうかを示すブール値。
* **`is_drawend`**: ダイアログの描画アニメーションが終了したかどうかを示すブール値。
* **`callback`**: イベント
  - **`onopen()`**: ダイアログが開いた
  - **`onclose()`**: ダイアログが閉じた

#### メソッド

* **`constructor(bnd: Bounds, btns = 0, font)`**: バウンズ、ボタンの種類、フォントなどを設定し、ダイアログの初期状態（コンテンツ、ボタン、アニメーション関連プロパティ）を初期化します。
* **`loadJSON(data)`**: JSONオブジェクトからプロパティを読み込みます。
* **`generateBtn()`**: `btntype`に基づいてOK、YES/NO、YES/NO/CANCELボタンを生成し、`buttons`リストに追加します。
* **`addContents(ui)`**: ダイアログ内にUI要素を追加し、その位置をダイアログのコンテンツ領域に合わせて調整します。テキストの場合は折り返しも処理します。
* **`recalcText(index)`**: 指定されたインデックスのテキストUI要素の折り返しを再計算します。
* **`checkPressed()`**: ダイアログ内のどのボタンが押されたかを示すオブジェクト（例: `{ ok: true }`）を返します。
* **`checkKeys()`**: キーマネージャーからの入力に基づいて、ダイアログ内のどのボタンが押されたかを示すオブジェクトを返します。
* **`open()`**: ダイアログを開き、描画アニメーションを開始します。`GameUI.isOpenWindow`を`true`に設定します。
* **`isOpen()`**: ダイアログの開くアニメーションが終了しているかどうかを返します。
* **`close()`**: ダイアログを閉じ、描画状態をリセットし、`GameUI.isOpenWindow`を`false`に設定します。
* **`update()`**: ダイアログの描画アニメーションを処理し、描画終了後は内部のUI要素とボタンを更新します。
* **`draw()`**: ダイアログの背景と内容を描画します。開くアニメーション中は部分的に描画し、アニメーション終了後は画面全体を半透明の背景で覆ってからダイアログを描画します。

#### Note(基本):  
* テキスト以外のUI要素も`contents`に追加することができます。

* ダイアログは開くまでは画面に表示されません。キーボードやボタン等と組み合わせて表示して使用することになります。

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


#### Note(ダイアログとしての利用):  
  
ダイアログには`contents`以外に使用するボタンを表示できます。それぞれ、目的に応じて生成時に`btns` に `BTNLIST`の値をセットしてください。

* OKボタンのみ: `GUIDialog.BTNLIST.OK`
* Yes, Noボタン: `GUIDialog.BTNLIST.YESNO`
* Yes, No, Cancelボタン: `GUIDialog.BTNLIST.YESNOCANCEL`
* ボタンなし: `GUIDialog.BTNLIST.CUSTOM`

ダイアログのこれらのボタンの戻り値は`checkPressed` または`checkKeys` メソッドで取得します。

戻り値は次の形式になっています。基本的には`checkPressed()`で判断します。

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
  if chk.actioned then //---なんらかのボタンがおされたとき
  end

  dlg.checkKeys()
end
```

`checkKeys()` を使うとキーボードやゲームパッドでの入力を取得してそのままボタン操作できます。  
`checkKeys()` は`checkPressed()`と戻り値は同じです。これにより、ゲームとして決定キー・キャンセルキーの実際のキーが違っていても、次のようにボタンが対応します。


* OKボタン: 決定キー
* Yesボタン: 決定キー
* Cancelボタン: キャンセルキー

たとえば、いずれかのボタンを押したときにダイアログを閉じる場合、次のように実装する必要があります。

```
local dlgret = dlg.checkKeys()
if dlgret.actioned then
  dlg.close()
end
```
 

---

### `GUIContainer`
複数のUI要素をまとめるための汎用コンテナクラスです。

#### プロパティ

* **`color`**: コンテナの背景色。
* **`filled`**: コンテナを塗りつぶすかどうかを示すブール値。
* **`radius`**: コンテナの角の丸み。
* **`contents`**: コンテナ内に含まれるUI要素のリスト。
* **`font`**: コンテナ内で使用されるフォント。

#### メソッド

* **`constructor(bnd: Bounds, font, bgcolor = "#FFF")`**: バウンズ、フォント、背景色などを設定します。
* **`loadJSON(data)`**: JSONオブジェクトからプロパティを読み込みます。
* **`addContents(ui)`**: コンテナ内にUI要素を追加し、位置を調整します。テキストの場合は折り返しも処理します。
* **`recalcText(index)`**: 指定されたインデックスのテキストUI要素の折り返しを再計算します。
* **`update()`**: 内部のUI要素の位置を計算し、更新します。
* **`draw()`**: コンテナの背景と内部のUI要素を描画します。

#### Note:  
他のUI要素を含められる、汎用的につかえるクラスです。コンテナ自体を描画する場合は`color`や`filled`に色を指定してください。

また、`GUIContainer` は`GUIScrollArea`の子要素としても使えます。

```
local cont = new GUIContainer(new Bounds(0,0,8,30),this.font,"#A88")
local txt = new GUIText("foo bar baz:" + param,new Bounds(2,5,80,20),this.font,"#FFF")
cond.addContents(txt)
```


---

### `GUIScrollArea`
内部のUI要素をスクロールして表示するための領域クラスです。

#### プロパティ

* **`color`**: スクロールエリアの背景色。
* **`filled`**: スクロールエリアを塗りつぶすかどうかを示すブール値。
* **`radius`**: スクロールエリアの角の丸み。
* **`contents`**: スクロールエリア内のすべてのUI要素のリスト。
* **`show_contents`**: 現在表示されているUI要素のリスト。
* **`font`**: スクロールエリア内で使用されるフォント。
* **`cury`**: 表示されているコンテンツの開始インデックス。
* **`maxy`**: 表示されているコンテンツの終了インデックス。
* **`first_content`**: 最初のコンテンツ要素への参照。
* **`last_content`**: 最後のコンテンツ要素への参照。
* **`show_row`**: 1行に表示するコンテンツの数。
* **`item_margin`**: アイテム間のマージン（x, y）。
* **`oldtouches`**: 前回のタッチ座標を記録するオブジェクト（x, y）。
* **`callback`**: イベント
  - **`onscroll(y)`**: スクロールした

#### メソッド

* **`constructor(bnd: Bounds, font, bgcolor = "#FFF")`**: バウンズ、フォント、背景色などを設定します。
* **`loadJSON(data)`**: JSONオブジェクトからプロパティを読み込みます。
* **`calculatePos()`**: コンテンツの最初の要素と最後の要素を計算します。
* **`clearContents()`**: スクロールエリア内のすべてのコンテンツをクリアし、関連するプロパティをリセットします。
* **`addContents(ui)`**: スクロールエリアにUI要素を追加します。表示領域に収まるように幅を調整し、`show_contents`にも追加します。
* **`recalcText(index)`**: 指定されたインデックスのテキストUI要素の折り返しを再計算します。
* **`scrollY(y)`**: スクロール量を指定してコンテンツをスクロールします。`cury`と`maxy`を更新し、`show_contents`を再構築します。
* **`update()`**: マウスホイールやタッチスワイプの入力に基づいてスクロールを処理し、表示されているコンテンツの位置を更新します。
* **`draw()`**: スクロールエリアの背景と、現在表示されているUI要素を描画します。

#### Note:  
子要素が自身の描画領域`bounds`を超える場合、超える要素は非表示になります。マウスホイールやスワイプでスクロールして残りの子要素を表示できます。


子要素は同じ幅・高さである必要があります。次のような生成処理にすることを推奨します。

関数を使い、子要素を決まった形で生成します。  
子要素は、`GUIContainer`にすることを推奨します。`GUIContainer` の子要素としてテキストやボタンを追加すると管理しやすくなります。
`GUIContainer`の子要素に制限はありません。  

それからアンカーはわかりやすくなるように左上(x=-1, y=1)になるように設定することを推奨します。



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

#### 注意(`GUIContainer`や`GUIScrollArea` の子要素の位置):

子要素は親である`GUIContainer`や`GUIScrollArea`のBoundsが起点となって計算されます。宣言時に子要素に指定するnew Bounds()ではあくまで親要素からの相対位置を指定することになります。


---

### `GUIListBox`
`GUIScrollArea` を継承した、選択可能な項目を持つリストボックスUI要素クラスです。

#### プロパティ

* **`uitype`**: UI要素のタイプ（`TYPELIST.LISTBOX`）。
* **`pushbgcolor`**: 項目が押された時の背景色。
* **`fontcolor`**: 項目のフォント色。
* **`selectcolor`**: 選択された項目の背景色。
* **`itemheight`**: 各項目の高さ。
* **`item_str`**: リストボックスに表示される文字列の配列。
* **`selectIndex`**: 現在選択されている項目のインデックス。
* **`old.selectIndex`**: 古いインデックス。
* **`callback`**: イベント
  - **`onchange(newval, oldval)`**: 選択時に実行するコールバック関数。`select`メソッド使用時には実行されない。

#### メソッド

* **`constructor(bnd: Bounds, font, items = [], bgcolor = "#FFF", pushbgcolor = "#AAA", fontcolor = "#000", selcolor = "rgba(100,100,100,0.2)")`**: リストボックスのインスタンスを初期化し、バウンズ、フォント、項目、色などを設定します。親クラスのコンストラクタを呼び出し、`uitype`を`TYPELIST.LISTBOX`に設定します。
* **`loadJSON(data)`**: JSONオブジェクトからプロパティを読み込みます。
* **`generate_item(lststr, itemheight)`**: 指定された文字列リストと項目高さに基づいて、リストボックスの項目を生成します。既存の項目をクリアし、各項目を`GUIButton`として追加します。
* **`select(index)`**: 指定されたインデックスの項目を選択します。インデックスが有効な範囲内であれば`true`を、そうでなければ`false`を返します。
* **`update()`**: 親クラスの`update`メソッドを呼び出し、クリックされた項目に基づいて`selectIndex`を更新します。
* **`draw()`**: 親クラスの`draw`メソッドを呼び出し、選択されている項目が可視領域内にある場合、その項目の背景に選択色を描画します。

#### Note:  
親の`GUIScrollArea`と異なり、文字列のリスト`items`を引数にして生成します。  
子要素は選択可能なアイテムとなり、カーソルやマウス・タップで選択できるようになります。  
もちろんスクロールして残りのアイテムの表示もできます。

---

### `UIGridMap`
UI間のカーソルの移動を管理します。

#### プロパティ

* **`uimanager`**: `GameUIManager` のインスタンス。UI要素の管理に使用されます。
* **`keymanager`**: `KeyManager` のインスタンス。キー入力の管理に使用されます。
* **`map`**: UI要素（またはその名前の文字列）の2次元配列。
* **`uigroup`**: このグリッドマップが操作するUIグループの名前。
* **`cursor`**: 現在選択されているUI要素を示す`Bounds`オブジェクト。
* **`cursorColor`**: カーソルの色。
* **`cursorAlpha`**: カーソルの透明度。
* **`cursorAlphaVelocity`**: カーソルの透明度の変化速度。
* **`select`**: 現在選択されているUI要素。
* **`enable_cursor`**: カーソルの表示を有効にするかどうかを示すブール値。
* **`framedur`**: 1フレームあたりの持続時間（ミリ秒）。
* **`lasttime`**: 前回の更新時のシステム時刻。
* **`now`**: 現在のシステム時刻。
* **`callback`**: イベント
  - **`onhitui(gridx, gridy, ui)`**: カーソルがUIにヒットした場合に実行します。（グリッド上のX, Y, UIオブジェクト）
  - **`onreachedge(dirx, diry)`**: カーソルがこれ以上移動できない端に到達した場合に実行します（移動方向X, Y）

#### メソッド

* **`constructor(uiman: GameUIManager, keyman: KeyManager, group)`**: `UIGridMap`のインスタンスを初期化し、UIマネージャー、キーマネージャー、操作対象のUIグループ、マップ、カーソル関連のプロパティを設定します。
* **`generate_fromcsv(csv)`**: CSVデータ(カンマ区切り)からマップを生成します。
* **`appendRow(cols)`**: マップに新しい行を追加します。
* **`select(x, y)`**: 指定されたマップ座標のUI要素を選択します。
* **`getIndex(ui)`**: 指定されたUI要素のマップ上のインデックス（x, y）を返します。
* **`uiOpertionCheck(dirx, diry)`**: UI操作（カーソル移動やマウス/タッチヒット）をチェックします。`dirx`と`diry`で指定された方向に移動可能なUI要素を検索したり、マウス/タッチ入力による選択を処理します。また、UI要素の`roundui`プロパティも利用して隣接要素への移動を試みます。
* **`update()`**: カーソルの点滅アニメーションと、選択中のUI要素（チェックボックスやラジオボタン）に対する決定キー入力を処理します。
* **`draw()`**: カーソルが有効な場合、選択されているUI要素の周りにカーソルを描画します。

#### Note:  
UIのグループごとに`UIGridMap`を使うことで、画面内のUI要素間のカーソル移動を制御することができます。

`appendRow` で列のリストを登録するか、`generate_fromcsv`でまとめて登録できます。  
`generate_fromcsv`の場合は、UI要素の名前を文字列のList型として渡す必要があります。

登録できるのは次の通りです。
* UI要素の`name`
* UI要素自身（`appendRow`のみ）


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

* 実際にカーソルを表示して移動を描画するには、`enable_cursor` プロパティに`true`をセットしてください。
* update関数では`KeyManager.update`から返る方向の情報を、`UIGridMap.uiOperationCheck`に受け渡して判定します。
* `UIGridMap.uiOperationCheck`の後に `UIGridMap.update`を呼び出します。


#### 細かい制御:  
上記の例だと、chkからbtn_scrdownにカーソルを移動させることができません。特定のUI要素間のカーソル移動を制御するには、次のようにしてください。

`GameUI` から継承している`roundui`の各方向のプロパティに、対象のUI要素の名前あるいは要素自身をセットしてください。`setDirectRound`メソッドで方向と移動先のUIを指定できます。

```
chk.setDirectRound("right",btn_scrdown)
btn_scrdown.setDirectRound("up",chk)
//---same
chk.setRound(null,null,btn_scrdown,null)
btn_scrdown(chk,null,null,null)
```

こうすることで、chkから右キーを押すと、btn_scrdownに移動させることができます。



---

### `GUITextMessage`
メッセージを保持し、一文字ずつ表示するアニメーションを管理するクラス。`GUIContainer`を継承。

#### プロパティ
* **`messages`**: 表示する文章のリスト。
* **`alltext`**: 現在のメッセージ全文を保持する`GUIText`。内部参照用。
* **`showtext`**: 画面に表示中のテキストを保持する`GUIText`。内部参照用。
* **`is_forwarding`**: テキスト送りアニメーションが実行中かどうかのフラグ。`messages`の最後まで到達すると`false`になります。
* **`curmsg_index`**: 現在表示しているメッセージ`messages`のインデックス。
* **`drawtime`**: 描画にかかるフレーム数
* **`callback`**: イベント
  - **`onpageend(pageindex, pagetext)`**: 1ページ描画終わった時に実行するコールバック関数。

#### メソッド
* **`constructor = function(bnd: Bounds, textlst = [], font = 0, fontcolor)`**: `GUITextMessage` をインスタンス化します。
* **`loadJSON(data)`**: JSONオブジェクトからプロパティを読み込みます。
* **`setMessageList(msgs)`**: 表示するメッセージのリストを設定します。
* **`goForward(dir)`**: 次(1)または前(-1)のメッセージに進み、アニメーションを開始します。
* **`goFirst(is_cleartext = false)`**: メッセージを一番最初に戻します。戻しつつ表示中のメッセージを消去する場合は `is_cleartext` をtrueにします。
* **`update()`**: 一定間隔で`showtext`に文字を追加し、アニメーションを更新します。
* **`draw()`**: `showtext`の内容を描画します。

#### Note:  
ゲーム中にメッセージを表示する際、1単語（日本語の場合は1文字）ずつ表示します。  
表示するスピードは`drawtime`の値で調整できます。

```
local msgs = [
  "Micheal: Hello. This is a pen.",
  "Mary: OK. Good bye!",
  "マリオ: キノコ大好きだよ！"
]
msg = new GUITextMessage(new Bounds(0, 0, 120, 30),msgs,font,"#FFF")
```


メッセージを進めるまたは戻るには、 `goForward()` メソッドをキー入力やボタン操作時に合わせて使用してください。

```
//---キー操作の場合
if keymanager.checkDecide() then
  msg.goForward(1)
end
//---ボタン操作時
btn.callback = function()
  msg.goForward(1)
end
```
