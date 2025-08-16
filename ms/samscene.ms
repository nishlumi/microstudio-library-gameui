SceneFirst = class
  constructor = function(gsys, uiman, keyman)
    this.uiman = uiman
    this.keyman = keyman
    this.grpname = "first"
    this.uiman.addGroup(this.grpname)
    this.scr = gsys
    this.font = this.scr.fonts[0]
    
    
    //---GUIText
    this.txt = new GUIText("アイテムのリストから選択するためのマテリアルデザインボタン。",
      new Bounds(this.scr.left+10,90,120,8),this.font,"#FFF"
    )
    this.txt.anchorx = -1
    this.txt.anchory = 1
    this.uiman.add(this.txt, this.grpname)
    
    //---GUICheckbox
    this.chk = new GUICheckbox("アップル",new Bounds(this.scr.left+10,30,75,10),false,this.font,"#FFF")
    this.uiman.add(this.chk, this.grpname)
    this.chk.callback.onchange = function(checked)
      print("scene 1 checkbox:" + checked)
    end
    
    //---GUIRadiobutton
    this.rad1 = new GUIRadiobutton("Yes","yesno",new Bounds(this.scr.left+10,0,75,10),true,this.font,"#FFF")
    this.rad2 = new GUIRadiobutton("NO","yesno",new Bounds(this.scr.left+10,-this.font.size-4,75,10),false,this.font,"#FFF")
    this.uiman.add(this.rad1, this.grpname)
    this.uiman.add(this.rad2, this.grpname)
    local radcb = function(value)
      print("scene 1 radiobutton:" + value)
    end
    this.rad1.callback.onchange = radcb
    this.rad2.callback.onchange = radcb
    
    //---GUISlider (horizontal)
    this.sld = new GUISlider(new Bounds(this.scr.left+10,this.scr.bottom+50,70,20),0,0,50,1,false)
    this.uiman.add(this.sld, this.grpname)
    this.sld.callback.onchange = function(newval, oldval)
      print("scene 1 slider:" + oldval.toString() + " -> " + newval.toString())
    end
    
    //---GUIScrollArea & GUIContainer (as Children of GUIScrollArea)
    this.scrl = new GUIScrollArea(new Bounds(0,0,142,110),this.font, "#855")
    this.scrl.selectable = true
    this.scrl.show_row = 2
    this.scrl.item_margin.y = 2
    this.scrl.addContents(this.create_childcont(1))
    this.scrl.addContents(this.create_childcont(2))
    this.scrl.addContents(this.create_childcont(3))
    this.scrl.addContents(this.create_childcont(4))
    this.scrl.addContents(this.create_childcont(5))
    this.scrl.addContents(this.create_childcont(6))
    this.scrl.addContents(this.create_childcont(7))
    this.scrl.addContents(this.create_childcont(8))
    this.uiman.add(this.scrl, this.grpname)
    this.scrl.callback.onscroll = function(y)
      print("scene 1 scroll:" + y.toString())
    end
    
    //---button to operate GUIScrollArea
    this.btn_scrup = new GUIButton("/\\",new Bounds(this.scr.right-30,-55,30,15),this.font,"#AAA","#888", "#000",true,3)
    this.btn_scrup.callback.onpress = function()
      this.scrl.scrollY(-1)
    end
    this.btn_scrdown = new GUIButton("\/",new Bounds(this.scr.right-60,-55,30,15),this.font,"#AAA","#888", "#000",true,3)
    this.btn_scrdown.callback.onpress = function()
      this.scrl.scrollY(1)
    end
    this.uiman.add(this.btn_scrup, this.grpname)
    this.uiman.add(this.btn_scrdown, this.grpname)
    
    //---manually key mapper for GUICheckbox, GUIRadiobox
    this.chk.setDirectRound("right",this.btn_scrdown)
    this.rad1.setDirectRound("right",this.btn_scrdown)
    
    this.create_gridmap()
    
    
  end
  create_gridmap = function()
    //---Set keymaps for multiple UIs at once
    this.gridmap = new UIGridMap(this.uiman, this.keyman, this.grpname)
    //this.gridmap.appendRow([this.chk,"",""])
    //this.gridmap.appendRow([this.rad1,"",""])
    //this.gridmap.appendRow([this.rad2,"",""])
    //this.gridmap.appendRow([this.sld,this.btn_scrup,this.btn_scrdown])
    
    local csv = [
      [this.chk.name,"","",""],
      [this.chk.name,"","",""],
      [this.rad1.name,"","",""],
      [this.rad2.name,"","",""],
      [this.sld.name,this.btn_scrdown.name,this.btn_scrup.name]
    ]
    this.gridmap.generate_fromcsv(csv)
    this.gridmap.enable_cursor = true
    
    this.gridmap.events.onreachedge = function(x, y)
      print("cursor move is " + x.toString() + ":" + y.toString())
    end
  end
  create_childcont = function(n)
    //---Child for GUIScrollArea
    local cont = new GUIContainer(new Bounds(0,0,70,30),this.font,"#A88")
    cont.setAnchor(-1,1)
    cont.name = "container_" + n
    local c1 = new GUICheckbox("OK?",new Bounds(2,8,36,40),false,this.font,"#FFF")
    c1.setAnchor(-1,1)
    cont.addContents(c1)
    local c2 = new GUIButton(n + "??",new Bounds(46,3,70-46,25),this.font)
    c2.setAnchor(-1,1)
    cont.addContents(c2)
    return cont
  end
  update = function()
    local dir = this.scr.update()
    this.scr.uiupdate(this.grpname)
    //this.keyman.update()
    //local dirx = dir.x //this.keyman.is_right() - this.keyman.is_left()
    //local diry = dir.y //this.keyman.is_down() - this.keyman.is_up()
    if this.keyman.is_right() or  this.keyman.is_left() or this.keyman.is_up() or this.keyman.is_down() then
      //print("dirx=" + dir.x + " : diry=" + dir.y)
    end
    if this.scr.fps.each(5) then  
      this.gridmap.uiOpertionCheck(dir.x, dir.y)
    end
    this.gridmap.update()
  end
  draw = function()
    this.scr.uidraw(this.grpname)
    this.gridmap.draw()
  end
end
//======================================================================
SceneSecond = class
  constructor = function(gsys,uiman,keyman)
    this.uiman = uiman
    this.keyman = keyman
    this.grpname = "second"
    this.uiman.addGroup(this.grpname)
    this.scr = gsys
    this.font = this.scr.fonts[0]
    
    //---GUIRect
    this.rct = new GUIRect(new Bounds(this.scr.left+30,-30,30,25),"#F03",true,0)
    this.rct.setAnchor(-1,1)
    this.rct.filled = false
    this.uiman.add(this.rct,this.grpname)
    
    //---GUIDialog
    this.dlg1 = new GUIDialog(new Bounds(0,0,150,65),GUIDialog.BTNLIST.OK,this.font)
    this.dlg1.callback.onopen = function(y)
      print("scene 2 dialog open")
    end
    this.dlg1.callback.onclose = function(y)
      print("scene 2 dialog close")
    end
    //---Children for GUIDialog
    local dlgtext = new GUIText("Let's start game!",new Bounds(5,5,dlg1.bounds.w*0.8,this.font.size*2),this.font,"#000")
    dlgtext.setAnchor(-1,1)
    this.dlg1.addContents(dlgtext)
    local dlgicon = new GUIImage(5, 15, "icon", new Bounds(0,0,16,16),0,1)
    dlgicon.setAnchor(-1,1)
    this.dlg1.addContents(dlgicon)
    this.uiman.add(this.dlg1,this.grpname)
    
    //---GUIButton & callback & call Dialog
    local ca1 = function()
      print("this is a pen!")
      if this.dlg1 then
        if this.dlg1.isOpen() then
          this.dlg1.close()
        else
          this.dlg1.open()
        end
      end
    end
    this.btn2 = new GUIButton("猫",new Bounds(this.scr.right-30,this.scr.top-10,30,30),this.font,"#3F3","#1A1", "#FFF",true,3,ca1)
    this.btn2.shadow.offset.x = 1
    this.btn2.shadow.offset.y = -1
    this.btn2.shadow.color = "#888"
    this.uiman.add(this.btn2,this.grpname)
    
    //---GUIListbox
    local lstitem = ["hoge","foot","bar","idea","adam"]
    this.lstbox = new GUIListBox(new Bounds(this.scr.right-30,0, 40, 80),this.font,[])
    this.lstbox.generate_item(lstitem, 17)
    this.lstbox.callback.onchange = function(newval, oldval)
      this.txtval.setText(newval.toString())
    end
    this.uiman.add(this.lstbox,this.grpname)
    
    this.txt = new GUIText("select:",new Bounds(this.scr.right-200, this.scr.top-50,70,20),this.font,"#F00")
    this.txt.setAnchor(-1,1)
    this.uiman.add(this.txt, this.grpname)
    this.txtval = new GUIText("-1",new Bounds(this.scr.right-150, this.scr.top-50,30,20),this.font,"#F00")
    this.txtval.setAnchor(-1,1)
    this.uiman.add(this.txtval, this.grpname)

    
  end
  update = function()
    this.scr.update()
    this.scr.uiupdate(this.grpname)
    //this.keyman.update()
    if this.dlg1.isOpen() then
      local ret = this.dlg1.checkKeys(keyman)
      if ret.ok then
        print("ok pressed: enter ?")
        this.dlg1.close()
      end
    end
    /*if this.keyman.checkDecide("p") then
      this.msg.goForward(1)
    end
    if this.keyman.checkCancel("p") then
      this.msg.goFirst()
    end*/
  end
  draw = function()
    this.scr.uidraw(this.grpname)
  end
end
//======================================================================
SceneThird = class
  constructor = function(gsys,uiman,keyman)
    this.uiman = uiman
    this.keyman = keyman
    this.grpname = "third"
    this.uiman.addGroup(this.grpname)
    this.scr = gsys
    this.font = this.scr.fonts[0]
    
    //---GUIText
    this.txt = new GUIText("RPG Message test.",new Bounds(this.scr.left+3, this.scr.top-3,120,20),this.font,"#F00")
    this.txt.setAnchor(-1,1)
    this.txt2 = new GUIText("progress=Enter, reset=Reset button",new Bounds(this.scr.left+8, this.scr.top-15,200,20),this.font,"#F00")
    this.txt2.setAnchor(-1,1)
    this.uiman.add(this.txt, this.grpname)
    this.uiman.add(this.txt2, this.grpname)
    
    //---GUISlider
    //this.sld = new GUISlider(new Bounds(this.scr.right-100,this.scr.top-10,70,20),1,1,10,1,false)
    //this.uiman.add(this.sld, this.grpname)
    
    //---GUITextMessage
    local msgs = [
      "Micheal: Hello. This is a pen.",
      "Mary: OK. Good bye!",
      "マリオ: キノコ大好きだよ！"
    ]
    this.msg = new GUITextMessage(new Bounds(this.scr.left+3,this.scr.top-35, 120, 30),msgs,this.font,"#FFF")
    this.uiman.add(this.msg, this.grpname)
    this.msg.callback.onpageend = function(index, text)
      print("scene 3 message:" + index.toString() + ":" + text)
    end
    
    this.resetbtn = new GUIButton("Reset",new Bounds(this.scr.right-100,this.scr.bottom+80,50,35), this.font)
    this.resetbtn.callback = function()
      this.msg.goFirst(true)
    end
    this.uiman.add(this.resetbtn, this.grpname)
  end
  update = function()
    this.scr.update()
    this.scr.uiupdate(this.grpname)
    //this.keyman.update()
    this.msg.drawtime = this.sld.curval
    
    if this.keyman.checkDecide("p") then
      this.msg.goForward(1)
    end
    if keyboard.Q then
      this.msg.goFirst()
    end
  end
  draw = function()
    this.scr.uidraw(this.grpname)
  end
end
//========================================================-
SceneFourth = class
  constructor = function(gsys,uiman,keyman)
    this.uiman = uiman
    this.keyman = keyman
    this.grpname = "fourth"
    this.uiman.addGroup(this.grpname)
    this.scr = gsys
    this.font = this.scr.fonts[0]
    
    asset_manager.loadJSON("scene4", function(data)
      this.uiman.addFromJSON(data)
      this.testbtn = this.uiman.getObject("testbtn",this.grpname)
      this.testdlg = this.uiman.getObject("testdialog",this.grpname)
      
      this.testbtn.callback = function()
        //this.testdlg.open()
        system.prompt("kore?", function(ok, text)
          print(ok, text)
        end)
      end
      this.create_gridmap(this.uiman.addGridMapFromJSON(data))
    end)
    
    
  end
  create_gridmap = function(data)
    //---Set keymaps for multiple UIs at once
    this.gridmap = new UIGridMap(this.uiman, this.keyman, this.grpname)
    
    this.gridmap.generate_fromcsv(data)
    this.gridmap.enable_cursor = true
  end
  update = function()
    local dir = this.scr.update()
    this.scr.uiupdate(this.grpname)
    //this.keyman.update()
    
    //------close with keypress
    if this.testdlg.isOpen() then
      local dlgact = this.testdlg.checkKeys()
      if dlgact.actioned then
        this.testdlg.close()
      end
    else
      if this.scr.fps.each(5) then  
        this.gridmap.uiOpertionCheck(dir.x, dir.y)
      end
      this.gridmap.update()
    end
  end
  draw = function()
    this.scr.uidraw(this.grpname)
    this.gridmap.draw()
  end
end