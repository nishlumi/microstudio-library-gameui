/*
  GameUI library
  
  It makes it easier to create UI in your game.
  
  version: 1.0.0
  
*/

GameUI = class
  
  isOpenWindow = false
  constructor = function (uitype, bounds, rotate = 0, scale = 1)
    this.name = TYPELIST.getKey(uitype) + "_" + system.time() + round(random.next()*100)
    this.referlist = object end
    this.bounds = bounds
    this.tmpbnds = new Bounds(bounds)
    this.endx = this.bounds.x + this.bounds.w
    this.endy = this.bounds.y - this.bounds.h
    this.anchorx = 0
    this.anchory = 0
    this.uitype = uitype
    //---future reserve
    this.roundui = object
      up = null
      left = null
      right = null
      bottom = null
    end
    this.selectable = false
    this.focusable = true
    this.enabled = true
    /**
    *
    * @type {GameUIManager}
    **/
    this.parent = null
    /**
    *
    * @type {KeyManager}
    **/
    this.keyman = null
    this.rotate = rotate
    this.scale = scale
    this.alpha = 1
    this.uigroup = ""
    //---free paramater area
    this.tmpparam = object end
    this.fps = new GUIFPS()
    this.font = null
    this.callback = object end

    this.old = object
      touched = false
      entered = false
    end
    
  end
  loadJSON = function(data)
    if data.include("name") then this.name = data.name end
    if data.include("bounds") then 
      this.bounds = new Bounds(data.bounds)
      this.tmpbnds = new Bounds(bounds)
      this.endx = this.bounds.x + this.bounds.w
      this.endy = this.bounds.y - this.bounds.h
    end
    if data.include("anchor") then
      if data.anchor.include("x") then this.anchorx = data.anchor.x end
      if data.anchor.include("y") then this.anchory = data.anchor.y end
    end
    if data.include("selectable") then this.selectable = data.selectable end
    if data.include("focusable") then this.focusable = data.focusable end
    if data.include("enabled") then this.enabled = data.enabled end
    if data.include("rotate") then this.rotate = data.rotate end
    if data.include("scale") then this.scale = data.scale end
    if data.include("alpha") then this.alpha = data.alpha end
    if data.include("roundui") then
      if data.roundui.include("up") then this.roundui.up = data.roundui.up end
      if data.roundui.include("left") then this.roundui.left = data.roundui.left end
      if data.roundui.include("right") then this.roundui.right = data.roundui.right end
      if data.roundui.include("bottom") then this.roundui.bottom = data.roundui.bottom end
    end
  end
  getObject = function(name)
    local ret = null
    if this.referlist.include(name) then
      ret = this.referlist[name]
    else
      for r in this.referlist
        if (
           (this.referlist[r].uitype == TYPELIST.SCROLLAREA) or
           (this.referlist[r].uitype == TYPELIST.CONTAINER) 
        )
        then
          for lcon in this.referlist[r].contents
            if lcon.name == name then
              ret = lcon
              break
            end
          end
          /*if this.referlist[r].contents.include(name) then
            ret = this.referlist[r].contents[name]
            break
          end*/
        end
      end
    end
    return ret
  end
  setDirectRound = function(label, ui)
    if ui.type == "string" then
      this.roundui[label] = this.getObject(ui)
    else
      this.roundui[label] = ui
    end
  end
  setRound = function(upui = null, leftui = null, rightui = null, bottomui = null)
    local tmpobj = object
      up = upui
      left = leftui
      right = rightui
      bottom = bottomui
    end
    for k in tmpobj
      if tmpobj[k] then
        if tmpobj[k].type == "string" then
          roundui[k] = this.getObject(tmpobj[k])
        else
          roundui[k] = tmpobj[k]
        end
      end
    end
  end
  setPos = function(x,y)
    this.bounds.x = x
    this.bounds.y = y
  end
  calcPosByAnchor = function(ax, ay)
    local ret = object x = this.bounds.x y = this.bounds.y end
    if (ax == 1) and (this.anchorx !=  1) then
      ret.x = this.bounds.x + this.bounds.w/2
    elsif (ax == -1) and (this.anchorx != -1) then
      ret.x = this.bounds.x - this.bounds.w/2
    end
    if (ay == 1) and (this.anchory != 1) then
      ret.y = this.bounds.y + this.bounds.h/2
    elsif (ay == -1) and (this.anchory != -1) then
      ret.y = this.bounds.y - this.bounds.h/2
    end
    return ret
  end
  setAnchor = function(x, y)
    this.anchorx = x
    this.anchory = y
  end
  setSize = function(w, h)
    this.bounds.w = w
    this.bounds.h = h
    this.endx = this.bounds.x + this.bounds.w
    this.endy = this.bounds.y - this.bounds.h
  end
  checkTouchArea = function(x, y)
    local ishit = false
    local sx = 0
    local sy = 0
    local ex = 0
    local ey = 0
    //---calculate topleft -> bottom-right
    if this.anchorx == 1 then
      sx = this.bounds.x - this.bounds.w
      ex = this.bounds.x
    elsif this.anchorx == -1 then
      sx = this.bounds.x
      ex = this.bounds.x + this.bounds.w
    else
      sx = this.bounds.x - this.bounds.w/2
      ex = this.bounds.x + this.bounds.w/2
    end
    if this.anchory == 1 then
      sy = this.bounds.y
      ey = this.bounds.y - this.bounds.h
    elsif this.anchory == -1 then
      sy = this.bounds.y + this.bounds.h
      ey = this.bounds.y
    else
      sy = this.bounds.y + this.bounds.h/2
      ey = this.bounds.y - this.bounds.h/2
    end
    //print("name=" + this.name + ", anchor:" + this.anchorx + ":" + this.anchory)
    //print(sx + "-->" + ex + " ( " + mouse.x + ":" + mouse.y + " ) " + sy + "-->" + ey)
    
    ishit = x.checkRange(sx, ex) and y.checkRange(ey, sy)
    //print("    -> hit=" + ishit)
    if not this.focusable then
      ishit = false
    end
    return ishit
  end
  fired_event = function()
    //---common events
    if mouse.release  then
      if this.checkTouchArea(mouse.x, mouse.y) then
        if (this.callback.onclick) and (this.callback.onclick.type == "function") then
          (this.callback.onclick)()
        end
      end
    elsif touch.release then
      if this.checkTouchArea(touch.touches[0].x, touch.touches[0].y) then
        if (this.callback.onclick) and (this.callback.onclick.type == "function") then
          (this.callback.onclick)()
        end
      end
    else
      local entered = this.checkTouchArea(mouse.x, mouse.y)
      local lbnd = new Bounds(mouse.x, mouse.y, 0, 0)
      if touch.touches.length > 0 then
        entered = this.checkTouchArea(touch.touches[0].x, touch.touches[0].y)
        lbnd.x = touch.touches[0].x
        lbnd.y = touch.touches[0].y
      end
      
      if this.old.entered == false and entered == true then
        if (this.callback.onenter) and (this.callback.onenter.type == "function") then
          (this.callback.onenter)(lbnd)
        end
      end
      if this.old.entered == true and entered == true then
        if (this.callback.onstay) and (this.callback.onstay.type == "function") then
          (this.callback.onstay)(lbnd)
        end
      end
      if this.old.entered == true and entered == false then
        if (this.callback.onleave) and (this.callback.onleave.type == "function") then
          (this.callback.onleave)(lbnd)
        end
      end
      this.old.entered = entered
    end
  end
  update = function()
    this.fps.update()
    this.fired_event()
  end
  draw = function()
    screen.setDrawAnchor(this.anchorx, this.anchory)
    screen.setDrawScale(this.scale,this.scale)
    screen.setDrawRotation(this.rotate)
    screen.setAlpha(this.alpha)
  end
end

//==============================================================
GUIImage = class extends GameUI
  constructor = function(bnd, imagename, imagerect = 0, rotate = 0, scale = 1.0)
    local tmpw = 0
    local tmph = 0
    this.isCutSprite = false
    if not imagerect then
      if imagename != "" then
        tmpw = sprites[imagename].width
        tmph = sprites[imagename].height
      end
      this.img_bnd = new Bounds(0, 0, tmpw, tmph)
    else
      tmpw = imagerect.w
      tmph = imagerect.h
      this.isCutSprite = true
      this.img_bnd = imagerect
    end
    super(TYPELIST.IMAGE, new Bounds(bnd.x, bnd.y, tmpw, tmph), rotate, scale)
    
    this.imagename  = imagename
    
    if this.isCutSprite then
      this.bounds.w = tmpw * this.scale
      this.bounds.h = tmph * this.scale
    end
    
  end
  loadJSON = function(data)
    super(data)
    local tmpw = 0
    local tmph = 0
    if data.include("isCutSprite") then this.isCutSprite = data.isCutSprite end
    if data.include("imagename") then this.imagename = data.imagename end
    if data.include("imagerect") then
      this.isCutSprite = true
      this.img_bnd = data.imagerect
    else
      if data.include("imagename") then
        this.img_bnd = new Bounds(0, 0, sprites[imagename].width, sprites[imagename].height)
      end
    end
    if this.isCutSprite then
      this.bounds.w = this.img_bnd.w * this.scale
      this.bounds.h = this.img_bnd.h * this.scale
    end
  end
  setImage = function (newimg)
    this.imagename = newimg.name
    this.img_bnd.x = newimg.x
    this.img_bnd.y = newimg.y
    this.img_bnd.w = newimg.w
    this.img_bnd.h = newimg.h
  end
  update = function()
    super()
  end
  draw = function()
    super()
    
    if this.isCutSprite then
      drawSpritePartBounds(this.imagename, this.img_bnd, this.bounds)
    else
      screen.drawSprite(this.imagename, this.bounds.x, this.bounds.y, this.img_bnd.w, this.img_bnd.h)
    end
  end
end


//==============================================================
GUIText = class extends GameUI
  constructor = function (text, bnd, font = 0, color1 = 0, color2 = 0,shifted_x = 0, shifted_y = 0)
    super(TYPELIST.TEXT, bnd)
    this.wrapper = multiTextSplitter(8, font.size+4)
    this.is_wrap = true
    this.realtexts = []
    this.text = text
    this.setText(text)
    this.color1 = color1
    this.color2 = color2
    this.shifted = object
      x = shifted_x
      y = shifted_y
    end
    this.font = font
    this.blink_time = 0
    
  end
  loadJSON = function(data)
    super(data)
    if data.include("text") then
      this.setText(data.text)
    end
    if data.include("color1") then this.color1 = data.color1 end
    if data.include("color2") then this.color2 = data.color2 end
    if data.include("shifted") then
      local shifted = data.shifted
      if shifted.include("x") then this.shifted.x = shifted.x end
      if shifted.include("y") then this.shifted.y = shifted.y end
    end
  end
  setText = function(txt)
    this.realtexts.clear()
    local oldtext = this.text
    this.text = txt
    //this.bounds.w = this.bounds
    this.bounds.h = this.font.size
    this.endx = this.bounds.x + this.bounds.w
    this.endy = this.bounds.y + this.bounds.h
    //---calculate wrappered text
    if this.is_wrap then
      this.recalcWrap()
    else
      this.realtexts.push(this.text)
    end
    
    if (this.callback.onchange) and (this.callback.onchange.type == "function") then
      (this.callback.onchange)(txt, oldtext)
    end
  end
  recalcWrap = function()
    this.realtexts = this.wrapper.wrapText(this.text, this.bounds.w)
  end
  refreshText = function(width)
    this.bounds.w = width
    this.recalcWrap()
  end
  clear = function()
    this.realtexts.clear()
    this.text = ""
  end
  update = function()
    super()
  end
  draw = function()
    super()
    if this.realtexts.length == 0 then
      return
    end
    screen.setFont(this.font.name)
    for i = 0 to this.realtexts.length-1
      local line = this.realtexts[i]
      if (this.shifted.x != 0) or (this.shifted.y != 0) then
        screen.drawText(line, this.bounds.x+this.this.shifted.x, this.bounds.y-this.shifted.y - i * this.wrapper.charHeight, this.font.size, this.color2)
      end
      screen.drawText(line, this.bounds.x, this.bounds.y - i * this.wrapper.charHeight, this.font.size, this.color1)
    end
  end
    
end
//==============================================================
GUICheckbox = class extends GameUI
  constructor = function (text, bnd, chked = 0, font = 0, color1 = 0, color2 = 0,shifted_x = 0, shifted_y = 0)
    super(TYPELIST.CHECKBOX, new Bounds(bnd.x, bnd.y, 8, 8))
    this.pressed = false
    this.checked = false
    this.old["checked"] = false
    this.text = new GUIText(text, new Bounds(bnd.x+12, bnd.y, bnd.w, bnd.h), font, color1, color2, shifted_x, shifted_y)
    this.text.setAnchor(-1,1)
    this.selectable = true
    this.checkColor = "#FFF"
    this.setAnchor(-1,1)
    
  end
  loadJSON = function(data)
    super(data)
    this.text.loadJSON(data)
    //---forcely set
    this.bounds.w = 8
    this.bounds.h = 8
    
    if data.include("checked") then this.checked = data.checked end
    if data.include("selectable") then this.selectable = data.selectable end
    if data.include("checkColor") then this.checkColor = data.checkColor end
  end
  setFont = function(font)
    this.text.font = font
  end
  checkTouchArea = function(x, y)
    local ishit  = super(x, y)
    if x.checkRange(this.bounds.x, this.bounds.x+this.bounds.w+this.text.bounds.w) and y.checkRange(this.bounds.y-this.bounds.h, this.bounds.y) then
      ishit = true
    else
      ishit = false
    end
    if not this.selectable then
      ishit = false
    end
    return ishit
  end
  check = function()
    this.checked = not this.checked
  end
  uncheck = function()
    this.checked = false
  end
  update = function()
    if this.parent == null then
      if GameUI.isOpenWindow then
        return
      end
    end
    
    super()
    if mouse.release then
      if not this.pressed and this.checkTouchArea((mouse.x), (mouse.y)) then
          this.pressed = true
          this.checked = not this.checked
      end
    elsif (touch.release) then
      if not this.pressed and this.checkTouchArea((touch.touches[0].x), (touch.touches[0].y)) then
          this.pressed = true
          this.checked = not this.checked
      end
    else
      this.pressed = false
    end
    
    
    this.text.setPos(this.bounds.x+12, this.bounds.y)
    this.text.update()
    
    if this.old.checked != this.checked then
      if (this.callback.onchange) and (this.callback.onchange.type == "function") then
        (this.callback.onchange)(this.checked)
      end
    end
    this.old.checked = this.checked
  end
  draw = function ()
    super()
    if this.checked then
      screen.fillRect(this.bounds.x, this.bounds.y, this.bounds.w, this.bounds.h, this.checkColor)
    else
      screen.drawRect(this.bounds.x, this.bounds.y, this.bounds.w, this.bounds.h, this.checkColor)
    end
    this.text.draw()
  end
  
end
//==============================================================
GUIRadiobutton = class extends GameUI
  constructor = function (text, grpname, bnd, chked = 0, font = 0, color1 = 0, color2 = 0,shifted_x = 0, shifted_y = 0)
    super(TYPELIST.RADIOBUTTON, new Bounds(bnd.x, bnd.y, 8, 8))
    this.pressed = false
    this.checked = false
    this.oldchecked = false
    this.text = new GUIText(text, new Bounds(bnd.x+12, bnd.y, bnd.w, bnd.h), font, color1, color2, shifted_x, shifted_y)
    this.text.setAnchor(-1,1)
    this.selectable = true
    this.checkColor = "#FFF"
    this.group = grpname
    this.setAnchor(-1,1)
    this.value = 
    this.old["value"] = ""
    
  end
  loadJSON = function(data)
    super(data)
    this.text.loadJSON(data)
    //---forcely set
    this.bounds.w = 8
    this.bounds.h = 8
    
    if data.include("checked") then this.checked = data.checked end
    if data.include("selectable") then this.selectable = data.selectable end
    if data.include("checkColor") then this.checkColor = data.checkColor end
    if data.include("group") then this.group = data.group end
  end
  setFont = function(font)
    this.text.font = font
  end
  checkTouchArea = function(x, y)
    local ishit = super(x, y)
    if x.checkRange(this.bounds.x, this.bounds.x+this.bounds.w+this.text.bounds.w) and y.checkRange(this.bounds.y-this.bounds.h, this.bounds.y) then
      ishit = true
    else
      ishit = false
    end
    if not this.selectable then
      ishit = false
    end
    return ishit
  end
  check = function()
    for e in this.referlist
      if (
        (this.referlist[e].uitype == TYPELIST.RADIOBUTTON) and 
        (this.referlist[e].group == this.group) and
        (this.referlist[e].name != this.name)
      )
      then
        this.referlist[e].checked = false
      end
    end
    this.checked = true
  end
  uncheck = function()
    this.checked = false
  end
  getGroupValue = function()
    local ret = ""
    for e in this.referlist
      if (
        (this.referlist[e].uitype == TYPELIST.RADIOBUTTON) and 
        (this.referlist[e].group == this.group) and
        (this.referlist[e].checked == true)
      )
      then
        ret = this.referlist[e].name
        break
      end
    end
    return ret
  end
  update = function()
    if this.parent == null then
      if GameUI.isOpenWindow then
        return
      end
    end
    
    if mouse.release then
      if not this.pressed and this.checkTouchArea((mouse.x), (mouse.y)) then
        for e in this.referlist
          if (
            (this.referlist[e].uitype == TYPELIST.RADIOBUTTON) and 
            (this.referlist[e].group == this.group) and
            (this.referlist[e].name != this.name)
          )
          then
            this.referlist[e].checked = false
          end
        end
        this.pressed = true
        
        this.checked = true
        this.value = this.name
        
        if this.checked then
          if (this.callback.onchange) and (this.callback.onchange.type == "function") then
            (this.callback.onchange)(this.value)
          end
        end
      end
    elsif (touch.release) then
      if not this.pressed and this.checkTouchArea((touch.touches[0].x), (touch.touches[0].y)) then
          for e in this.referlist
            if (
              (this.referlist[e].uitype == TYPELIST.RADIOBUTTON) and 
              (this.referlist[e].group == this.group) and
              (this.referlist[e].name != this.name)
            )
            then
              this.referlist[e].checked = false
            end
          end
          this.pressed = true
          this.checked = true
          this.value = this.name
          
          if this.checked then
            if (this.callback.onchange) and (this.callback.onchange.type == "function") then
              (this.callback.onchange)(this.value)
            end
          end
      end
    else
      this.pressed = false
    end
    
    
    
    this.old.value = this.value
    
    
    super()
    local lx = this.bounds.x+12
    this.text.setPos(lx, this.bounds.y)
    this.text.update()
  end
  draw = function ()
    super()
    if this.checked then
      screen.fillArc(this.bounds.x+this.bounds.w/2, this.bounds.y-this.bounds.h/2, this.bounds.w/2, 0, 360, true, this.checkColor)
    else
      screen.drawArc(this.bounds.x+this.bounds.w/2, this.bounds.y-this.bounds.h/2, this.bounds.w/2, 0, 360, true, this.checkColor)
    end
    this.text.draw()
  end
  
end

//==============================================================
GUIRect = class extends GameUI
  constructor = function (bnd, color, filled = true, radius = 0, transparency = 1, transparency_interval = 0)
    super(TYPELIST.RECT, bnd)
    this.color = color
    this.filled = filled
    this.radius = radius
    this.alpha = transparency
    this.transparencyInterval = transparency_interval
    this.setAnchor(0,0)
    
  end
  loadJSON = function(data)
    super(data)
    
    if data.include("color") then this.color = data.color end
    if data.include("filled") then this.filled = data.filled end
    if data.include("radius") then this.radius = data.radius end
    if data.include("alpha") then this.alpha = data.alpha end
    if data.include("transparencyInterval") then this.transparencyInterval = data.transparencyInterval end
  end
  update = function()
    super()
  end
  draw = function()
    super()
    if this.filled then
      if this.radius != 0 then
        screen.fillRoundRect(this.bounds.x,this.bounds.y,this.bounds.w,this.bounds.h,this.radius,this.color)
      else
        screen.fillRect(this.bounds.x,this.bounds.y,this.bounds.w,this.bounds.h,this.color)
      end
    else
      if this.radius != 0 then
        screen.drawRoundRect(this.bounds.x,this.bounds.y,this.bounds.w,this.bounds.h,this.radius,this.color)
      else
        screen.drawRect(this.bounds.x,this.bounds.y,this.bounds.w,this.bounds.h,this.color)
      end
    end
  end
  
end
//==============================================================
GUIButton = class extends GameUI
  constructor = function (text, bnd, font = 0, bgcolor = "#FF0", pushbgcolor = "#CC0", fontcolor = "#000", filled = true, radius = 0, callback = 0)
    super(TYPELIST.BUTTON, bnd)
    this.pressed = false
    this.filled = filled
    this.radius = radius
    this.text = new GUIText(text, new Bounds(bnd.x+(bnd.w)/2, bnd.y-(bnd.h)/2, bnd.w, bnd.h), font, fontcolor)
    this.bgcolor = bgcolor
    this.pushbgcolor = pushbgcolor
    this.curBgcolor = bgcolor
    this.callback["onpress"] = callback
    this.callback["onpressing"] = null
    this.setAnchor(-1,1)
    this.selectable = true
    this.shadow = object
      offset = object
        x = 0
        y = 0
      end
      color = "#000"
    end
  end
  loadJSON = function(data)
    super(data)
    this.text.loadJSON(data)
    
    if data.include("color") then this.color = data.color end
    if data.include("filled") then this.filled = data.filled end
    if data.include("radius") then this.radius = data.radius end
    if data.include("bgcolor") then this.bgcolor = data.bgcolor end
    if data.include("pushbgcolor") then this.pushbgcolor = data.pushbgcolor end
    if data.include("curBgcolor") then this.curBgcolor = data.curBgcolor end
    if data.include("shadow") then
      if data.shadow.include("offset") then
        if data.shadow.offset.include("x") then this.shadow.offset.x = data.shadow.offset.x end
        if data.shadow.offset.include("y") then this.shadow.offset.y = data.shadow.offset.y end
      end
      if data.shadow.include("color") then
        this.shadow.color = data.shadow.color
      end
      
    end
  end
  setFont = function(font)
    this.text.font = font
  end
  push = function()
    if this.callback.onpush then
      if this.callback.onpush.type == "function" then
        (this.callback.onpush)()
      end
    end
  end
  update = function()
    super()
    this.text.bounds.x = this.bounds.x +(this.bounds.w)/2
    this.text.bounds.y = this.bounds.y -(this.bounds.h)/2
    this.text.update()
    if this.parent == 0 then
      if GameUI.isOpenWindow then
        return
      end
    end
    
    if this.enabled then
      if mouse.release then
        //print(round(mouse.x) + ":" + round(mouse.y) + "-->" + (this.bounds.x + ":" + this.bounds.y + "-" + (this.bounds.x+this.bounds.w) + ":" + (this.bounds.y-this.bounds.h)))
        if not this.pressed and this.checkTouchArea((mouse.x), (mouse.y)) then
          this.pressed = true
          this.curBgcolor = this.pushbgcolor
          //print(1)
            
        end
      elsif (touch.release) then
        if not this.pressed and this.checkTouchArea((touch.touches[0].x), (touch.touches[0].y)) then
          this.pressed = true
          this.curBgcolor = this.pushbgcolor
        end
      else
        this.pressed = false
        this.curBgcolor = this.bgcolor
      end
      if this.pressed then
        if this.callback.onpress then
          if this.callback.onpress.type == "function" then
            (this.callback.onpress)()
          end
        end
      end
      
      if (mouse.pressed and this.checkTouchArea((mouse.x), (mouse.y)))
        or 
        (touch.touching and this.checkTouchArea((touch.touches[0].x), (touch.touches[0].y))) 
      then
        if this.callback.onpressing != null then
          (this.callback.onpressing)()
        end
      end
    end
  end
  draw = function ()
    super()
    if this.filled then
      if this.radius != 0 then
        screen.fillRoundRect(this.bounds.x+this.shadow.offset.x,this.bounds.y+this.shadow.offset.y,this.bounds.w,this.bounds.h,this.radius,this.shadow.color)
        screen.fillRoundRect(this.bounds.x,this.bounds.y,this.bounds.w,this.bounds.h,this.radius,this.curBgcolor)
      else
        screen.fillRect(this.bounds.x+this.shadow.offset.x,this.bounds.y+this.shadow.offset.y,this.bounds.w,this.bounds.h,this.shadow.color)
        screen.fillRect(this.bounds.x,this.bounds.y,this.bounds.w,this.bounds.h,this.curBgcolor)
      end
    else
      if this.radius != 0 then
        screen.drawRoundRect(this.bounds.x,this.bounds.y,this.bounds.w,this.bounds.h,this.radius,this.curBgcolor)
      else
        screen.drawRect(this.bounds.x,this.bounds.y,this.bounds.w,this.bounds.h,this.curBgcolor)
      end
    end
    this.text.draw()
  end
  
end


//==============================================================
GUISlider = class extends GameUI
  constructor = function (bnd, defaultval, minval, maxval, step, isVertical = false, bgcolor = "#999", barcolor = "#EEE", pushbarcolor = "#FFF")
    super(TYPELIST.SLIDER, bnd)
    this.pressed = false
    this.presspos = object
      x = 0
      y = 0
    end
    
    this.barcolor = barcolor
    this.pushbarcolor = pushbarcolor
    this.curBarcolor = barcolor
    this.bgcolor = bgcolor
    this.minvalue = minval
    this.maxvalue = maxval
    this.step = step
    this.value = defaultval
    this.old["value"] = this.curvalue
    this.isVertical = isVertical
    this.setAnchor(-1,1)
    this.selectable = true
    
    this.label = object
      enable = true
      size = 12
      x = 10
      y = 0
      color = this.barcolor
    end
    this.callback["onchange"] = null
    
    this.common_setup()
  end
  common_setup = function()
    this.barbnd = new Bounds(this.bounds.x, this.bounds.y, 5, this.bounds.h)
    if this.isVertical then
      this.barbnd.w = this.bounds.w
      this.barbnd.h = 5
    end
    this.real_x = 0
  end
  loadJSON = function(data)
    super(data)
    
    if data.include("barcolor") then this.barcolor = data.barcolor end
    if data.include("pushbarcolor") then this.pushbarcolor = data.pushbarcolor end
    if data.include("curBarcolor") then this.curBarcolor = data.curBarcolor end
    if data.include("value") then this.value = data.value end
    if data.include("minvalue") then this.minvalue = data.minvalue end
    if data.include("maxvalue") then this.maxvalue = data.maxvalue end
    if data.include("step") then this.step = data.step end
    if data.include("label") then
      if data.label.include("enable") then this.label.enable = data.label.enable end
      if data.label.include("size") then this.label.size = data.label.size end
      if data.label.include("x") then this.label.x = data.label.x end
      if data.label.include("y") then this.label.y = data.label.y end
    end
    if data.include("isVertical") then this.isVertical = data.isVertical end
    this.common_setup()
  end
  setValue = function(val)
    if val > 0 then
      
    elsif val < 0 then
    end
    local fullmmval = this.minval + this.maxval
    this.value += val
    local fullrate = fullmmval / this.curval
    
    if this.isVertical then
      local fulllen =  this.bounds.y + this.bounds.h - 2
      local zeromouse = this.bounds.h * fullrate
      local y = this.bounds.y + zeromouse
      
      this.barbnd.y = y
    else
      local fulllen =  this.bounds.x + this.bounds.w - 2
      local zeromouse = this.bounds.w * fullrate
      local x = this.bounds.x + zeromouse
      
      this.barbnd.x = x
    end
  end
  calclateBarPosition = function(x, y)
    this.presspos.x = x
    this.presspos.y = y
    
    //---calc
    if this.isVertical then
      local fulllen =  this.bounds.y - this.bounds.h + 2
      local zeromouse = round(round((round(y)-this.bounds.y) * 1000) / 1000)
      local fullrate = round(abs(zeromouse / this.bounds.h) * 1000) / 1000
      local fullmmval = this.minvalue + this.maxvalue
      local calccurval = round(fullmmval * fullrate)
      this.value = max(this.minvalue, min(calccurval, this.maxvalue))
      
      
      this.barbnd.x = this.bounds.x
      this.barbnd.y = min(this.bounds.y, max(y, fulllen))
    else
      local fulllen =  this.bounds.x + this.bounds.w - 2
      local zeromouse = round(round((round(x)-this.bounds.x) * 1000) / 1000)
      local fullrate = round(abs(zeromouse / this.bounds.w) * 1000) / 1000
      local fullmmval = this.minvalue + this.maxvalue
      local calccurval = round(fullmmval * fullrate)
      //print(this.bounds.x + "(" + zeromouse + ")" + " vs " + this.bounds.w)
      //print("2:  " + x + " / " + fulllen + "=" + fullrate)
      //print("3:   " + this.minval + "<" + fullrate + "_" + (calccurval) + "<" + this.maxval)
      this.value = max(this.minvalue, min(calccurval, this.maxvalue))
      
      
      this.barbnd.x = max(this.bounds.x, min(x, fulllen))
      this.barbnd.y = this.bounds.y
    end
  end
  update = function()
    super()
    if this.parent == null then
      if GameUI.isOpenWindow then
        return
      end
    end
    
    if this.enabled then
      if mouse.pressed then
        //print(round(mouse.x) + ":" + round(mouse.y) + "-->" + (this.bounds.x + ":" + this.bounds.y + "-" + (this.bounds.x+this.bounds.w) + ":" + (this.bounds.y-this.bounds.h)))
        if this.checkTouchArea((mouse.x), (mouse.y)) then
            this.pressed = true
            this.curBarcolor = this.pushbarcolor
            
            this.calclateBarPosition(mouse.x, mouse.y)
        end
      elsif (touch.touching and touch.press) then
        if not this.pressed and this.checkTouchArea((touch.touches[0].x), (touch.touches[0].y)) then
            this.pressed = true
            this.curBarcolor = this.pushbarcolor
            
            this.calclateBarPosition(touch.touches[0].x, touch.touches[0].y)
        end
      else
        this.pressed = false
        this.curBarcolor = this.barcolor
      end
      
      if this.value != this.old.value then
        if this.callback.onchange and (this.callback.onchange.type == "function") then
          (this.callback.onchange)(this.value, this.old.value)
        end
      end
      
      this.old.value = this.value
    end
  end
  draw = function()
    super()
    if this.isVertical then
      //---meter
      screen.fillRect(this.bounds.x+this.bounds.w*0.375, this.bounds.y+1,this.bounds.w*0.25,this.bounds.h-1,this.bgcolor)
      //---bar
      screen.fillRect(this.barbnd.x,this.barbnd.y,this.barbnd.w,this.barbnd.h,this.curBarcolor)
      //---label
      if this.label.enable then
        local labelx = this.barbnd.x + this.label.x
        local labely = this.bounds.y - this.bounds.h - this.label.y - 5
        screen.drawText(this.value, labelx, labely, this.label.size, this.label.color)
      end
    else
      //---meter
      screen.fillRect(this.bounds.x+1,this.bounds.y-this.bounds.h*0.375,this.bounds.w-1,this.bounds.h*0.25,this.bgcolor)
      //---bar
      screen.fillRect(this.barbnd.x,this.barbnd.y,this.barbnd.w,this.barbnd.h,this.curBarcolor)
      //---label
      if this.label.enable then
        local labelx = this.bounds.x + this.bounds.w + this.label.x
        local labely = this.barbnd.y + this.label.y
        screen.drawText(this.value, labelx, labely, this.label.size, this.label.color)
      end
    end
    
  end
end

//==============================================================
GUIDialog = class extends GameUI
  BTNLIST = object
    NOSETUP = -1
    OK = 0
    YESNO = 1
    YESNOCANCEL = 2
    CUSTOM = 3
  end
  constructor = function (bnd, btns = 0, font = null)
    super(TYPELIST.DIALOG, bnd)
    this.color = "#FFF"
    //this.setAnchor(-1,1)
    this.contents = []
    this.font = font
    this.buttons = []
    this.btntype = btns
    if btns != BTNLIST.NOSETUP then
      this.generateBtn()
    end
    this.drawtime = 30
    this.drawpart = object
      x = this.bounds.w / this.drawtime
      y = this.bounds.h / this.drawtime
    end
    this.curdraw = 0
    this.is_startdraw = false
    this.is_drawend = false
    
    this.callback["onopen"] = null
    this.callback["onclose"] = null
    
  end
  loadJSON = function(data)
    super(data)
    
    if data.include("color") then this.color = data.color end
    if data.include("btntype") then this.btntype = data.btntype end
    this.generateBtn()
    if data.include("drawtime") then
      this.drawtime = data.drawtime
      
    end
    this.drawpart.x = this.bounds.w / this.drawtime
    this.drawpart.y = this.bounds.h / this.drawtime
    
  end
  generateBtn = function()
    local lx = this.bounds.x + this.bounds.w/2
    local ly = this.bounds.y - this.bounds.h/2
    if this.btntype == BTNLIST.OK then
      local button = new GUIButton("OK",new Bounds(0, this.bounds.h + 8, 30, 15), this.font)
      button.bounds.x = lx - button.bounds.w - 4
      button.bounds.y = ly + button.bounds.h + 8
      button.parent = this
      button.callback.onpress = function()
        this.close()
      end
      //button.text.setText("OK")
      this.buttons.push(button)
    elsif this.btntype == BTNLIST.YESNO then
      local button2 = new GUIButton("NO",new Bounds(0, this.bounds.h + 8, 30, 15), this.font)
      button2.bounds.x = lx - button.bounds.w - 4
      button2.bounds.y = ly + button.bounds.h + 8
      button2.parent = this
      //button2.setText("NO")
      local button1 = new GUIButton("Yes",new Bounds(0, this.bounds.h + 8, 30, 15), this.font)
      button1.bounds.x = lx - button2.bounds.w - 4 - button.bounds.w - 4
      button1.bounds.y = ly + button.bounds.h + 8
      button1.parent = this
      //button1.text.setText("Yes")
      this.buttons.push(button1)
      this.buttons.push(button2)
    elsif this.btntype == BTNLIST.YESNOCANCEL then
      local button3 = new GUIButton("Cancel",new Bounds(0, this.bounds.h + 8, 30, 15), this.font)
      button3.bounds.x = lx - button.bounds.w - 4
      button3.bounds.y = ly + button.bounds.h + 8
      button3.parent = this
      
      //button2.setText("NO")
      local button2 = new GUIButton("No",new Bounds(0, this.bounds.h + 8, 30, 15), this.font)
      button2.bounds.x = lx - button3.bounds.w - 4 - button.bounds.w - 4
      button2.bounds.y = ly + button.bounds.h + 8
      button2.parent = this
      
      local button1 = new GUIButton("Yes",new Bounds(0, this.bounds.h + 8, 30, 15), this.font)
      button1.bounds.x = lx - button3.bounds.w - 4 - button2.bounds.w - 4 - button.bounds.w - 4
      button1.bounds.y = ly + button.bounds.h + 8
      button1.parent = this
      
      //button1.text.setText("Yes")
      this.buttons.push(button1)
      this.buttons.push(button2)
      this.buttons.push(button3)
    end
  end
  addContents = function(ui) 
    local lx = this.bounds.x - this.bounds.w/2
    local ly = this.bounds.y + this.bounds.h/2
    
    ui.bounds.x = lx + ui.bounds.x
    ui.bounds.y = ly - ui.bounds.y
    if ui.uitype == TYPELIST.TEXT then
      //ui.bounds.w = this.bounds.w
      ui.recalcWrap()
    end
    ui.parent = this
    this.contents.push(ui)
  end
  recalcText = function (index)
    this.contents[index].bounds.w = this.bounds.w
    if this.contents[index].uitype == TYPELIST.TEXT then
      this.contents[index].recalcWrap()
    end
  end
  checkPressed = function()
    local ret = object ok = false yes = false no = false cancel = false  actioned = false end
    if this.btntype == BTNLIST.OK then
      ret.ok = this.buttons[0].pressed
      if ret.ok then ret.actioned = true end
    elsif this.btntype == BTNLIST.YESNO then
      ret.yes = this.buttons[0].pressed
      ret.no = this.buttons[1].pressed
      if ret.yes or ret.no then
        ret.actioned = true
      end
    elsif this.btntype == BTNLIST.YESNOCANCEL then
      ret.yes = this.buttons[0].pressed
      ret.no = this.buttons[1].pressed
      ret.cancel = this.buttons[2].pressed
      if ret.yes or ret.no or ret.cancel then
        ret.actioned = true
      end
    end
    return ret
  end
  /**
  * check key to button
  * @param {KeyManager} keyman
  *
  */
  checkKeys = function()
    local ret = object ok = false yes = false no = false actioned = false end
    if this.btntype == BTNLIST.OK then
      ret.ok = this.keyman.checkDecide()
      if ret.ok then ret.actioned = true end
    elsif this.btntype == BTNLIST.YESNO then
      ret.yes = this.keyman.checkDecide()
      ret.no = this.buttons[1].pressed
      if ret.yes or ret.no then
        ret.actioned = true
      end
    elsif this.btntype == BTNLIST.YESNOCANCEL then
      ret.yes = this.keyman.checkDecide()
      ret.no = this.buttons[1].pressed
      ret.cancel = this.keyman.checkCancel()
      if ret.yes or ret.no or ret.cancel then
        ret.actioned = true
      end
    end
    return ret
  end
  open = function()
    this.is_startdraw = true
    GameUI.isOpenWindow = true
    if this.callback.onopen then
      if this.callback.onopen.type == "function" then
        (this.callback.onopen)()
      end
    end
  end
  isOpen = function()
    return this.is_drawend
  end
  close = function()
    this.is_startdraw = false
    this.is_drawend = false
    this.curdraw = 0
    for button in this.buttons
      button.pressed = false
    end
    GameUI.isOpenWindow = false
    if this.callback.onclose then
      if this.callback.onclose.type == "function" then
        (this.callback.onclose)()
      end
    end
  end
  update = function()
    super()
    local lx = this.bounds.x - this.bounds.w/2
    local ly = this.bounds.y + this.bounds.h/2
    
    if this.is_startdraw then
      if this.is_drawend then
        for u in this.contents
          u.update()
        end
        for b in this.buttons
          b.update()
        end
        //---other function
        
        
      else
        if this.curdraw <= this.drawtime then
          this.curdraw += 1
        else
          this.is_drawend = true
          this.curdraw = 0
        end
      end
    end
  end
  draw = function()
    if this.is_drawend then
      screen.setAlpha(0.35)
      screen.setDrawAnchor(0,0)
      screen.fillRect(0, 0, screen.width,screen.height,"#FFF")
      super()
      screen.fillRect(this.bounds.x,this.bounds.y,this.bounds.w,this.bounds.h,this.color)
      for u in this.contents
        u.draw()
      end
      for b in this.buttons
        b.draw()
      end
    else
      local w = this.drawpart.x * this.curdraw
      local h = this.drawpart.y * this.curdraw
      super()
      screen.fillRect(this.bounds.x,this.bounds.y,w,h,this.color)
      
    end
  end
  
end
//==============================================================
GUIContainer = class extends GameUI
  constructor = function (bnd, font, bgcolor = "#FFF")
    super(TYPELIST.CONTAINER, bnd)
    this.color = bgcolor
    this.filled = true
    this.radius = 0
    //this.setAnchor(-1,1)
    this.contents = []
    this.font = font

    
  end
  loadJSON = function(data)
    super(data)
    
    if data.include("color") then this.color = data.color end
    if data.include("radius") then this.radius = data.radius end
    
  end
  addContents = function(ui) 
    local lx = this.bounds.x - this.bounds.w/2
    local ly = this.bounds.y + this.bounds.h/2
    
    ui.bounds.x = lx + ui.bounds.x
    ui.bounds.y = ly - ui.bounds.y
    if ui.uitype == TYPELIST.TEXT then
      //ui.bounds.w = this.bounds.w
      ui.recalcWrap()
    end
    ui.parent = this
    this.contents.push(ui)
  end
  recalcText = function (index)
    this.contents[index].bounds.w = this.bounds.w
    if this.contents[index].uitype == TYPELIST.TEXT then
      this.contents[index].recalcWrap()
    end
  end
  update = function()
    super()
    //local lx = this.bounds.x - this.bounds.w/2
    //local ly = this.bounds.y + this.bounds.h/2
    
    for u in this.contents
      local l = this.calcPosByAnchor(u.anchorx, u.anchory)
      u.setPos(l.x+u.tmpbnds.x, l.y-u.tmpbnds.y)
      u.update()
    end
  end
  draw = function()
    super()
    if this.filled then
      if this.radius != 0 then
        screen.fillRoundRect(this.bounds.x,this.bounds.y,this.bounds.w,this.bounds.h,this.radius,this.color)
      else
        screen.fillRect(this.bounds.x,this.bounds.y,this.bounds.w,this.bounds.h,this.color)
      end
    else
      if this.radius != 0 then
        screen.drawRoundRect(this.bounds.x,this.bounds.y,this.bounds.w,this.bounds.h,this.radius,this.color)
      else
        screen.drawRect(this.bounds.x,this.bounds.y,this.bounds.w,this.bounds.h,this.color)
      end
    end
    for u in this.contents
      u.draw()
    end
  end
  
end

//==============================================================
GUIScrollArea = class extends GameUI
  constructor = function (bnd, font, bgcolor = "#FFF")
    super(TYPELIST.SCROLLAREA, bnd)
    this.color = bgcolor
    this.filled = true
    this.radius = 0
    //this.setAnchor(-1,1)
    //---contents is container/card only
    this.contents = []
    this.show_contents = []
    this.font = font
    
    //---showing contents start index
    this.cury = 0
    this.maxy = 0
    this.first_content = 0
    this.last_content = 0
    
    this.show_row = 1
    this.item_margin = object
      x = 0
      y = 0
    end
    this.oldtouches = object
      x = 0
      y = 0
    end
    this.callback["onscroll"] = null
    
  end
  loadJSON = function(data)
    super(data)
    
    if data.include("color") then this.color = data.color end
    if data.include("filled") then this.filled = data.filled end
    if data.include("radius") then this.radius = data.radius end
    if data.include("show_row") then this.show_row = data.show_row end
    
    if data.include("item_margin") then
      if data.item_margin.include("x") then this.item_margin.x = data.item_margin.x end
      if data.item_margin.include("y") then this.item_margin.y = data.item_margin.y end
    end
    
  end
  calculatePos = function()
    if this.contents.length > 0 then
      local con_sorted = this.contents.sortList(function(a,b)
        return a.bounds.y - b.bounds.y
      end)
      this.first_content = con_sorted[0]
      this.last_content = con_sorted[con_sorted.length-1]
    end
  end
  clearContents = function()
    this.contents.clear()
    this.show_contents.clear()
    this.first_content = null
    this.last_content = null
    this.cury = 0
    this.maxy = 0
  end
  addContents = function(ui) 
    local lx = this.bounds.x - this.bounds.w/2
    local ly = this.bounds.y + this.bounds.h/2
    
    ui.bounds.x = lx // + ui.bounds.w
    ui.bounds.y = ly //- ui.bounds.h
    if ui.uitype == TYPELIST.CONTAINER then
      for c in ui.contents
        c.bounds.x += lx
        c.bounds.y -= ly
      end
    elsif ui.uitype == TYPELIST.SCROLLAREA then
      for c in ui.contents
        c.bounds.x += lx
        c.bounds.y -= ly
      end
    end
    if ui.uitype == TYPELIST.TEXT then
      //ui.bounds.w = this.bounds.w
      ui.recalcWrap()
    end
    ui.parent = this
    //---adjust width of item row 
    ui.bounds.w = round(this.bounds.w / this.show_row)
    
    //---showing check
    local calc_fullw = 0
    local calc_fullh = 0
    local is_during_row = false
    for i = this.cury to this.contents.length-1
      local c = this.contents[i]
      
      if (calc_fullw+c.bounds.w) <= this.bounds.w then
        calc_fullw += c.bounds.w
        if not is_during_row then
          calc_fullh += c.bounds.h
        end
        is_during_row = true
      else
        if (calc_fullh+c.bounds.h) <= this.bounds.h then
          calc_fullh += c.bounds.h
          calc_fullw = 0
          is_during_row = false
        else
          break
        end
      end
    end
    
    this.contents.push(ui)
    if (calc_fullw+ui.bounds.w) <= this.bounds.w then
      //print("add col:" + ui.name + "--->" + calc_fullw + ":" + calc_fullh)
      this.show_contents.push(ui)
    else
      if (calc_fullh+ui.bounds.h) <= this.bounds.h then
        //print("add row:" + ui.name + "--->" + calc_fullw + ":" + calc_fullh)
        this.show_contents.push(ui)
      end
    end
    this.maxy = this.show_contents.length-1
    return ui
  end
  recalcText = function (index)
    this.contents[index].bounds.w = this.bounds.w
    if this.contents[index].uitype == TYPELIST.TEXT then
      this.contents[index].recalcWrap()
    end
  end
  /*
  *
  * @param {Number} y scroll value(relative value)
  *
  */
  scrollY = function(y)

    //print("-------------------")
    if (y > 0) and (
      (this.cury+(y * this.show_row) > this.contents.length-1 ) or 
      (this.maxy+(y * this.show_row) > this.contents.length-1 )
    ) then
      //print("limit: scroll to bottom (" + this.cury + "-" + this.maxy + ")")
      return
    end
    if (y < 0) and (this.cury+(y * this.show_row) < 0) then
      //print("limit: scroll to top (" + this.cury + "-" + this.maxy + ")")
      return
    end
    
    //---main
    //print("scroll before: " + this.cury + "~" + this.maxy)
    this.maxy = 0
    this.cury += (y * this.show_row)
    
    this.show_contents.clear()
    local calc_fullw = 0
    local calc_fullh = 0
    local is_during_row = false
    local setcolcnt = 0
    local currow_y = 0
    
    for i = this.cury to this.contents.length-1
      local c = this.contents[i]
      
      if setcolcnt < this.show_row then //(calc_fullw+c.bounds.w) <= this.bounds.w then
        calc_fullw += c.bounds.w + this.item_margin.x
        if setcolcnt == 0 then //not is_during_row then
          calc_fullh += c.bounds.h
        end
        is_during_row = true
        this.show_contents.push(c)
        this.maxy = i
        setcolcnt += 1
      else
        if (calc_fullh+c.bounds.h+this.item_margin.y) <= this.bounds.h then
          calc_fullh += c.bounds.h + this.item_margin.y
          calc_fullw = c.bounds.w + this.item_margin.x
          this.show_contents.push(c)
          this.maxy = i
          is_during_row = false
          setcolcnt = 1
        else
          break
        end
      end
    end
    //this.maxy = this.show_contents.length - 1
    //print("scroll after: " + this.cury + "~" + this.maxy)
  end
  update = function()
    super()
    local lx = this.bounds.x - this.bounds.w/2
    local ly = this.bounds.y + this.bounds.h/2
    
    local calc_fullw = 0
    local calc_fullh = 0//this.show_contents[0].bounds.h * -1
    local is_during_row = false
    local setcolcnt = 0
    local currow_y = 0
    if (mouse.wheel != 0)  then
      //print("    ->mouse wheel")
      if this.checkTouchArea(mouse.x, mouse.y) then
        //print("mouse wheel" + mouse.wheel + " -> " + (mouse.wheel*-1) + ", cury=" + this.cury)
        this.scrollY(mouse.wheel * -1)
        if this.callback.onscroll and (this.callback.onscroll.type == "function") then
          (this.callback.onscroll)(mouse.wheel * -1)
        end
      end
    end
    if touch.touching then
      if this.checkTouchArea(touch.touches[0].x, touch.touches[0].y) then
        if this.oldtouches.x == "x" then
          this.oldtouches.x = touch.touches[0].x
        end
        if this.oldtouches.y == "x" then
          this.oldtouches.y = touch.touches[0].y
        end
        local diffy = abs(touch.touches[0].y - this.oldtouches.y)
        //print(diffy)
        if diffy > 5 then
          if touch.touches[0].y > this.oldtouches.y then
            //print("up")
            this.scrollY(1)
            if this.callback.onscroll and (this.callback.onscroll.type == "function") then
              (this.callback.onscroll)(1)
            end
          elsif touch.touches[0].y < this.oldtouches.y then
            //print("down")
            this.scrollY(-1)
            if this.callback.onscroll and (this.callback.onscroll.type == "function") then
              (this.callback.onscroll)(-1)
            end
          end
        end
      end
      this.oldtouches.x = touch.touches[0].x
      this.oldtouches.y = touch.touches[0].y
    elsif touch.release then
      this.oldtouches.x = "x"
      this.oldtouches.y = "x"
    end
    for iu = 0 to  this.show_contents.length-1
      local u = this.show_contents[iu]
      //---get parent pos from child anchor value
      local l = this.calcPosByAnchor(u.anchorx, u.anchory)
      //if (calc_fullw+u.bounds.w) <= this.bounds.w then
      if setcolcnt < this.show_row then
        currow_y = l.y-u.tmpbnds.y-calc_fullh
        //print(u.name + ": " + l.y+", " + u.tmpbnds.y + "," + calc_fullh)
        u.setPos(l.x+u.tmpbnds.x+calc_fullw, currow_y-((max(0,iu-1))*this.item_margin.y))
        calc_fullw += u.bounds.w + this.item_margin.x
        is_during_row = true
        //if setcolcnt == 0 then //not is_during_row then
        //  calc_fullh += u.bounds.h
        //end
        setcolcnt += 1
      else
        if (calc_fullh+u.bounds.h+this.item_margin.y) <= this.bounds.h then
          calc_fullw = 0
          calc_fullh += u.bounds.h
          currow_y = l.y-u.tmpbnds.y-calc_fullh
          //print(u.name +"=" + calc_fullh)
          u.setPos(l.x+u.tmpbnds.x+calc_fullw, currow_y-(iu*this.item_margin.y))
          is_during_row = false
          setcolcnt = 1
          calc_fullw = u.bounds.w
          //calc_fullh += this.item_margin.y
        else
          break
        end
      end
      
      u.update()
    end
  end
  draw = function()
    super()
    if this.filled then
      if this.radius != 0 then
        screen.fillRoundRect(this.bounds.x,this.bounds.y,this.bounds.w,this.bounds.h,this.radius,this.color)
      else
        screen.fillRect(this.bounds.x,this.bounds.y,this.bounds.w,this.bounds.h,this.color)
      end
    else
      if this.radius != 0 then
        screen.drawRoundRect(this.bounds.x,this.bounds.y,this.bounds.w,this.bounds.h,this.radius,this.color)
      else
        screen.drawRect(this.bounds.x,this.bounds.y,this.bounds.w,this.bounds.h,this.color)
      end
    end
    for u in this.show_contents
      u.draw()
    end
  end
  
end

//==============================================================
GUIListBox = class extends GUIScrollArea
  constructor = function (bnd, font, items = [], bgcolor = "#FFF", pushbgcolor = "#AAA", fontcolor = "#000", selcolor = "rgba(100,100,100,0.2)")
    super(bnd, font, bgcolor)
    this.uitype = TYPELIST.LISTBOX
    this.pushbgcolor = pushbgcolor
    this.fontcolor = fontcolor
    this.selectcolor = selcolor
    this.itemheight = 25
    this.item_str = items
    this.selectIndex = -1
    this.old.selectIndex = -1
    this.callback["onchange"] = null
    this.generate_item(this.item_str, this.itemheight)
  end
  loadJSON = function(data)
    super(data)
    
    if data.include("pushbgcolor") then this.pushbgcolor = data.pushbgcolor end
    if data.include("fontcolor") then this.fontcolor = data.fontcolor end
    if data.include("selectcolor") then this.selectcolor = data.selectcolor end
    if data.include("itemheight") then this.itemheight = data.itemheight end
    
    if data.include("items") then
      this.item_str = data.items
      this.generate_item(this.item_str, this.itemheight)
    end
    
  end
  generate_item = function(lststr, itemheight)
    this.itemheight = itemheight
    this.item_str = lststr
    this.clearContents()
    for i = 0 to lststr.length-1
      local it = lststr[i]
      local inbtn = new GUIButton(it, new Bounds(0,0,this.bounds.x,itemheight), this.font, this.color, this.pushbgcolor, this.fontcolor)
      inbtn.tmpparam.index = i
      inbtn.setAnchor(-1,1)
      this.addContents(inbtn)
    end
  end
  select = function(index)
    if this.selectIndex.checkRange(0, this.contents.length-1) then
      this.selectIndex = index
      return true
    else
      return false
    end
  end
  update = function()
    super()
    for i = 0 to this.contents.length-1
      if this.contents[i].pressed then
        this.selectIndex = i
        //---only update cycle
        if this.selectIndex != this.old.selectIndex then
          if this.callback.onchange != null then
            (this.callback.onchange)(this.selectIndex,this.old.selectIndex)
          end
        end
        break
      end
    end
    
    this.old.selectIndex = this.selectIndex
  end
  draw = function()
    super()
    if this.selectIndex.checkRange(0, this.contents.length-1) then
      local selitem  = this.contents[this.selectIndex]
      if this.selectIndex.checkRange(this.cury, this.maxy) then
        screen.setDrawAnchor(selitem.anchorx, selitem.anchory)
        if this.fps.each(system.fps) then
          screen.setAlpha(1.0)
        else
          screen.setAlpha(0.25)
        end
        screen.fillRect(selitem.bounds.x, selitem.bounds.y, selitem.bounds.w, selitem.bounds.h, this.selectclor)
      end
    end
  end
end