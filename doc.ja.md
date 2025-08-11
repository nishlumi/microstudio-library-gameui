# GameUI ライブラリ


## 概要

このライブラリは一般的なUIを簡単に実装できるライブラリです。

* ボタン
* チェックボックス
* テキスト
* ダイアログ
* リストボックス
* UI間のカーソル移動
* ほかにも多くのUI

これらを簡単に実装して管理できます。

---

## 使用方法

### 基本の使い方

1. まず、GUISystemクラスのインスタンスを作成します。

* GUISystemはゲーム中に1つだけインスタンス化してください。

2. 必要に応じて GameUIManagerクラスである ``uimanager`` を取得します。

* 本ライブラリにおいて、最も重要なのが ``GameUIManager`` です。 

3. UIをグループ化するため、 ``addGroup`` で新たなUIグループ名を追加します。

* グループを分けない場合、最初から用意されている "default" を使うことができます。 

4. 好きなUIを定義していきます。
5. `GameUIManager`のaddメソッドで、UIを指定したグループに追加します。

* `addGroup` で追加したグループ名を指定することで、任意のUIグループにまとめることができます。

6. update関数では `GUISystem.update`と`GUISystem.uiupdate`を呼び出します。 **uiupdateはUIのグループごと** に呼び出します。
7. draw関数では `GUISystem.uidraw`を呼び出します。これもまたUIのグループごとに呼び出します。

```
init = function()
  gsys = new GUISystem()
  gsys.addFont("abcfont",10)
  
  //--GUISystem.uimanager は GameUIManagerクラス
  uiman = gsys.uimanager
  //---デフォルトでは "default" が定義されています
  //--- 画面ごとにUIをグルーピングしたい場合にaddGroupを使います
  uiman.addGroup("startpage")
  //---UIを定義する
  txt = new GUIText("アイテムのリストから選択するためのマテリアルデザインボタン。",
    new Bounds(gsys.left+10,90,120,8),gsys.fonts[0],"#FFF"
  )
  //---GameUIManagerの指定のグループにUIを追加する
  uiman.add(txt, grpname)
  //---他のUIも同様にする
  chk = new GUICheckbox("アップル",new Bounds(gsys.scr.left+10,30,75,10),false,gsys.fonts[0],"#FFF")
  uiman.add(chk, grpname)
end
update = function()
  gsys.update() //内部でKeyManager.updateも呼び出しています。
  gsys.uiupdate("default")
  gsys.uiupdate("startpage")
end
draw = function()
  gsys.uidraw("default")
  gsys.uidraw("startpage")
end
```

**各ポイント**

* `GUISystem.addFont`で使いたいフォントを定義します。（必要に応じてAssetsでフォントを追加してください。""はデフォルトのフォントを使います）
* GUISystem.left/right/top/bottomはゲーム画面の上下左右の位置を取得できます。
* UIの位置とサイズは主にBoundsクラスを使います。
* GameUIManagerのグループは、たとえばゲームのシーン（画面）ごとに定義するのに適しています

---

### ゲームコントローラーやキーボード操作用にカーソルの移動先を定義する

ゲームコントローラーなどでは、十字キーやスティックでゲーム内のUI間を移動することがあります。

本ライブラリではUI間の移動を簡単に定義できます。

1. UIGridMapクラスを使う
2. 各UIのsetDirectRoundメソッドを使う

後述のUIGridMapに詳しい解説を付けています。基本的にはこれだけでも十分にカーソル移動に対応できるでしょう。

2は、1だけでは制御できないUI間のカーソル移動をさせたい場合に有効です。こちらは必須ではありません。

---

### 各クラスのゲーム中の個数

|クラス|ゲーム中の個数|備考|
|-|-|-|
|GUISystem|1||
|GamaUIManager|1|GUISystem内で自動的にインスタンス化|
|KeyManager|1|GUISystem内で自動的にインスタンス化|
|UIGridMap|n|UIグループ1個につき1|

---

### JSONデータからUIを生成する

JSON形式のデータからUIをまとめて生成することもできます。

1. Assets にJSON形式のデータファイルを登録します。
2. `asset_manager.loadJSON` でデータを取得します。
3. `GameUIManager.addFromJSON(data)` を呼び出します。

作業用のプロパティやコールバック関数を指定するもの以外は全て指定することができます。

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

* `uitype`は必須です。
* `uigroup` を省略すると、"default" のUIグループに追加されます。


使用するには次のようにします。

```
scr = new GUISystem()
asset_manager.loadJSON("testui",function(data)
  scr.uimanager.addFromJSON(data)
end
```

また、GameUIManagerには `loadFromJSON`というメソッドも存在します。

こちらはJSONデータからUIを生成するところまでを行い、そのUIのListを返します。その後はUIを自由に扱えます。

UIを部分的に動的に追加したい場合などに使えます。

```
asset_manager.loadJSON("one_ui",function(data)
  local partsUI = scr.uimanager.loadFromJSON(data)
  scr.uimanager.addGroup("battle")
  for ui in partsUI
    scr.uimanager.add(ui, "battle")
  end
end
```

各UIはGameUIManager.drawを通さないと画面に描画はされないので、退避しておくことにも使えるでしょう。



**各クラスのloadJSON**

各クラスにも個別にデータファイルを読み込めるメソッド `loadJSON` を用意しています。

こちらはプロパティを一括してセットするのに使えます。

まずこのクラスのインスタンスを作っておき、個別にデータファイルを読み込んでloadJSONを呼び出せば、プロパティを一度に設定したり、子UIをソースコード上で定義する手間を省けます。

### GameUIManager外でも使いやすいクラス

`GUIAnimationImage` 、`GUIAnimationImageManager` はスプライト画像を複数束ねてアニメーションさせるために便利なクラスです。

これらはゲームのUIというわけではないので、`GameUIManager` の仕組みに含めず単独で使っても便利なクラスです。

独自のクラスなどに組み込む場合、 `update` と `draw` メソッドを忘れずに呼び出すようにしてください。

### マス目を意識した位置を設定できる

`GUISystem`には、`unit`というプロパティが存在します。これを `setUnit`メソッドで設定すると、その`unit`の単位で位置を指定できるようになります。

```
gsys = new GUISystem()
gsys.setUnit(16)
screen.drawRect(gsys.pos(0),gsys.pos(3),gsys.pos(5),gsys.pos(5))
//---In reality, the following is specified:
screen.drawRect(0, 3*16, 5*16, 5*16)
```

上記例だと、座標の単位を16にし、四角形を描画しています。
x=0, y=0の位置から、width=5,height=5という指定の意味になっています。

位置だけでなくサイズにも使えるので、ゲーム中での描画の位置の指定が管理しやすくなるでしょう。


## リファレンス

GitHubのページを参照してください (https://github.com/nishlumi/microstudio-library-gameui)。

