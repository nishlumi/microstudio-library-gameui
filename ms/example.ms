
init = function()
  local x = object 
    name = "this"
    age = 12
  end
  local a = [1,2,3,49,50,128]
  scr = new GUISystem()
  
  scr.callback.onResizeScreen = function (w,h)
    print("new wxh=" + w + h)
  end
  
  uiman = scr.uimanager
  keyman = scr.keymanager
  
  local y = new Bounds(0,0,0,0)
  
  /*
  //---GUIImage
  img = new GUIImage(new Bounds(0, 0, 0, 0), "icon", new Bounds(0,0,8,8),0,3)
  uiman.add(img,"default")
  
  //---GUISlider (vertical)
  sld = new GUISlider(new Bounds(this.scr.right-40,this.scr.top-10,20,70),1,1,3,1,true)
  uiman.add(sld, "default")
  
  //---GUIAnimationImageManager & GUIImage
  aimgman = new GUIAnimationImageManager(new Bounds(-60,0,128/4, 192/4))
  aimgman.addAnimation("bottom")
  aimgman.moveDict["bottom"].addImage([
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
  
  aimgman.addAnimation("right")
  aimgman.moveDict["right"].addImage([
    new GUIImage(new Bounds(0,0,0,0), "ch03_elenoa", new Bounds(32*0, 48*2, 128/4, 192/4)),
    new GUIImage(new Bounds(0,0,0,0), "ch03_elenoa", new Bounds(32*1, 48*2, 128/4, 192/4)),
    new GUIImage(new Bounds(0,0,0,0), "ch03_elenoa", new Bounds(32*2, 48*2, 128/4, 192/4)),
    new GUIImage(new Bounds(0,0,0,0), "ch03_elenoa", new Bounds(32*3, 48*2, 128/4, 192/4))
  ])
  aimgman.moveDict["right"].looptype = GUIAnimationImage.LOOPTYPE.TOBEGIN
  
  aimgman.addAnimation("up")
  aimgman.moveDict["up"].addImage([
    new GUIImage(new Bounds(0,0,0,0), "ch03_elenoa", new Bounds(32*0, 48*3, 128/4, 192/4)),
    new GUIImage(new Bounds(0,0,0,0), "ch03_elenoa", new Bounds(32*1, 48*3, 128/4, 192/4)),
    new GUIImage(new Bounds(0,0,0,0), "ch03_elenoa", new Bounds(32*2, 48*3, 128/4, 192/4)),
    new GUIImage(new Bounds(0,0,0,0), "ch03_elenoa", new Bounds(32*3, 48*3, 128/4, 192/4))
  ])
  aimgman.moveDict["up"].looptype = GUIAnimationImage.LOOPTYPE.TOBEGIN
  
  uiman.add(aimgman)
  aimgman.curMove = "bottom"
  */
  testrect1 = new GUIRect(new Bounds(scr.pos(10),scr.pos(10),scr.pos(3),scr.pos(3)), "#0FF")
  scr.uimanager.add(testrect1,"default")
  
  asset_manager.loadJSON("testui",function(data)
    
    scr.uimanager.addFromJSON(data)
  
    aimgman = scr.uimanager.getObject("aimgman")
  
    scr.addFont("",10)
    local ft = scr.fonts[0] //new GameFont("",10)
    
    //---create sample scene
    fscene = new SceneFirst(scr, uiman,keyman)
    sscene = new SceneSecond(scr, uiman,keyman)
    tscene = new SceneThird(scr, uiman,keyman)
    fourscene = new SceneFourth(scr, uiman,keyman)
    curscene = null
    //---change scene buttons
    //---GUIBUtton & callback functions
    ca0 = function()
      curscene = null
      print("curscene is 0")
      aimgman.cur().play()
    end
    local btn0 = new GUIButton("To default",new Bounds(scr.left,scr.bottom+20,60,20),ft,"#3F3","#1A1", "#FFF",true,3,ca0)
    btn0.name = "btn0"
    
    ca1 = function()
      curscene = fscene
      print("curscene is 1")
      aimgman.cur().stop()
    end
    local btn1 = new GUIButton("Scene 1",new Bounds(scr.left+60,scr.bottom+20,60,20),ft,"#3F3","#1A1", "#FFF",true,3,ca1)
    btn1.name = "btn1"
    
    ca2 = function()
      curscene = sscene
      print("curscene is 2")
      aimgman.cur().stop()
    end
    local btn2 = new GUIButton("Scene 2",new Bounds(scr.left+120,scr.bottom+20,60,20),ft,"#3F3","#1A1", "#FFF",true,3,ca2)
    btn2.name = "btn2"
    
    ca3 = function()
      curscene = tscene
      print("curscene is 3")
      aimgman.cur().play()
    end
    local btn3 = new GUIButton("Scene 3",new Bounds(scr.left+180,scr.bottom+20,60,20),ft,"#3F3","#1A1", "#FFF",true,3,ca3)
    btn3.name = "btn3"
    
    ca4 = function()
      curscene = fourscene
      print("curscene is 4")
      aimgman.cur().play()
    end
    local btn4 = new GUIButton("Scene 4",new Bounds(scr.left+240,scr.bottom+20,60,20),ft,"#3F3","#1A1", "#FFF",true,3,ca4)
    btn4.name = "btn4"
    
    uiman.add(btn0,"default")
    uiman.add(btn1,"default")
    uiman.add(btn2,"default")
    uiman.add(btn3,"default")
    uiman.add(btn4,"default")
  end)
  
  
  
  
  
  
  //---other sample controls
  
end

update = function()
  //img.setPos(0, 0)
  //txt.setPos(-130,75)
  //rct.filled = 0
  //rct.radius = 50
  //btn1.setPos(-5,0)
  
  /*
  for e in uiman.ui
    uiman.ui[e].update()
  end
  if dlg1.isOpen() then
    local ret = dlg1.checkKeys(keyman)
    if ret.ok then
      print("ok pressed: enter ?")
      dlg1.close()
    end
  end
  
    local dirx = keyman.is_right() - keyman.is_left()
    local diry = keyman.is_down() - keyman.is_up()
    if keyman.is_right() or  keyman.is_left() or keyman.is_up() or keyman.is_down() then
      print("dirx=" + dirx + " : diry=" + diry)
    end
  if scr.fps.each(5) then  
    gridmap.uiOpertionCheck(dirx, diry)
  end
  gridmap.update()
  */
  scr.update()
  scr.uiupdate("default")
  if keyman.is_left() then
    aimgman.curMove = "left"
  end
  if keyman.is_right() then
    aimgman.curMove = "right"
  end
  if keyman.is_down() then
    aimgman.curMove = "bottom"
  end
  if keyman.is_up() then
    aimgman.curMove = "up"
  end
  if curscene != null then
    curscene.update()
  end
  
  //---
  if scr.fps.each(30) then
    testrect1.setPos(scr.pos(random.nextInt(10)),testrect1.bounds.y)
  end
  //uiman.update("default")
end

draw = function()
  screen.clear()
  //drawSpritePartBounds("icon",new Bounds(0,0,8,8), new Bounds(0,0,8*1,8*1))
  /*for e in uiman.ui
    uiman.ui[e].draw()
  end*/
  scr.uidraw("default")
  if curscene != null then
    curscene.draw()
  end
  
end