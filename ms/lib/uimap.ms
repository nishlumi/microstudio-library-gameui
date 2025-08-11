UIGridMap = class
  constructor = function (uiman, keyman, group)
    /**
    *
    * @type {GameUIManager} 
    */
    this.uimanager = uiman
    /**
    *
    * @type {KeyManager} 
    */
    this.keymanager = keyman
    /**
    * 
    * @type {Array<Array<UI/String>>}
    *
    */
    this.map =[]
    
    this.uigroup = group
    
    this.cursor = new Bounds(0,0,0,0)
    this.cursorColor = "#F00"
    this.cursorAlpha = 1.0
    this.cursorAlphaVelocity = 0.25
    this.select = null
    
    this.enable_cursor = false
    this.framedur = 1000 / 60
    this.lasttime = system.time()
    this.now = this.lasttime
    
    this.events = object
      //---function(gridx, gridy, ui)
      onHitUI = null
      //---function(dirx, diry)
      onReachEdge = null
    end
    //print(this.events)
  end
  generate_fromcsv = function(csv)
    for acsv in csv
      this.map.push(acsv)
    end
  end
  appendRow = function(cols)
    this.map.push(cols)
  end
  select = function (x, y)
    if not y.checkRange(0,this.map.length-1) then
      return false
    end
    if not x.checkRange(0, this.map[y].length-1) then
      return false
    end
    local ui = this.map[y][x]
    local uiobj = null
    if ui.type == "string" then
      uiobj = this.uimanager.ui[this.uigroup][ui]
    elsif ui.type == "object" then
      uiobj = ui
    end
    this.cursor.x = x
    this.cursor.y = y
    this.cursor.w = uiobj.bounds.w+4
    this.cursor.h = uiobj.bounds.h+4
    this.select = uiobj
    return true
  end
  getIndex = function (ui) 
    local ret = object
      x = -1
      y = -1
    end
    for r = 0 to this.map.length-1
      for c = 0 to this.map[r].length-1
        local mapitem = this.map[r][c]
        if mapitem != "" then
          local uiobj = null
          if mapitem.type == "string" then
            uiobj = this.uimanager.ui[this.uigroup][mapitem]
          else
            uiobj = mapitem
          end
          //---start check
          if ui.type == "string" then
            if ui == uiobj.name then
              ret.x = c
              ret.y = r
            end
          else
            if ui.name == uiobj.name then
              ret.x = c
              ret.y = r
            end
          end
        end
      end
    end
    return ret
  end
  uiOpertionCheck = function (dirx, diry)
    local ishit = object 
      cursor = false
      mouse_hit  = false
      mouse_already = false
    end
    
    local lx = this.cursor.x + dirx
    local ly = this.cursor.y + diry
    local uiobj = null
    local hit = false
    if dirx != 0 or diry != 0 then
      //---check uimap, this is basic.
      while true
        if this.map[ly][lx] != "" then
          if this.map[ly][lx].type == "string" then
            //uiobj = this.uimanager.ui[this.uigroup][this.map[ly][lx]]
            uiobj = this.uimanager.getObject(this.map[ly][lx], this.uigroup)
          elsif this.map[ly][lx].type == "object" then
            uiobj = this.map[ly][lx]
          end
          if uiobj and uiobj.selectable then
            print("selectable:" + uiobj.name + "->" + uiobj.bounds.w + ":" + uiobj.bounds.h)
            hit = true
            break
          end
        end
        lx += dirx
        ly += diry
        
        
        if (
          (this.map.length <= ly) or 
          (this.map[ly].length <= lx) or
          (ly < 0) or (lx < 0)
        )
        then
          hit = false
          //---reach event
          if (lx < 0) then
            if this.events.onReachEdge and this.events.onReachEdge.type == "function" then
              (this.events.onReachEdge)(-1,0)
            end
          end
          if (this.map[ly].length <= lx) then
            if this.events.onReachEdge and this.events.onReachEdge.type == "function" then
              (this.events.onReachEdge)(1,0)
            end
          end
          if (ly < 0) then
            if this.events.onReachEdge and this.events.onReachEdge.type == "function" then
              (this.events.onReachEdge)(0,1)
            end
          end
          if (this.map.length <= ly) then
            if this.events.onReachEdge and this.events.onReachEdge.type == "function" then
              (this.events.onReachEdge)(0,-1)
            end
          end
          break
        end
        
      end
      //print("lx=" + lx + " : ly=" + ly)
    end
    if hit then
      this.cursor.x = lx
      this.cursor.y = ly
      //print("cursor x=" + this.cursor.x + " :  cursor y=" + this.cursor.y + " --> " + uiobj.name)
      this.cursor.w = uiobj.bounds.w+4
      this.cursor.h = uiobj.bounds.h+4
      this.select = uiobj
      ishit.cursor = true
      if this.events.onHitUI and this.events.onHitUI.type == "function" then
        (this.events.onHitUI)(lx, ly, uiobj)
      end
    else
      //---check roundui, ui has
      if this.map[this.cursor.y][this.cursor.x].type == "string" then
        uiobj = this.uimanager.ui[this.uigroup][this.map[this.cursor.y][this.cursor.x]]
        uiobj = this.uimanager.getObject(this.map[this.cursor.y][this.cursor.x], this.uigroup)
      elsif this.map[this.cursor.y][this.cursor.x].type == "object" then
        uiobj = this.map[this.cursor.y][this.cursor.x]
      end
      local roundui = null
      local dircondx = object
        left = -1
        right = 1
      end
      local dircondy = object
        up = 1
        bottom = -1
      end
      local dirkey = dircondx.getKey(dirx)
      if dirkey != "" then
        if uiobj.roundui[dirkey].type == "string" then
          roundui = this.uimanager.getObject(uiobj.roundui[dirkey], uiobj.uigroup)
        else
          roundui = uiobj.roundui[dirkey]
        end
      end
      dirkey = dircondy.getKey(diry)
      if dirkey != "" then
        if uiobj.roundui[dirkey].type == "string" then
          roundui = this.uimanager.getObject(uiobj.roundui[dirkey], uiobj.uigroup)
        else
          roundui = uiobj.roundui[dirkey]
        end
      end
      if roundui then
        local rhit = this.getIndex(roundui)
        if rhit.x != -1 and rhit != -1 then
          this.cursor.x = rhit.x
          this.cursor.y = rhit.y
          //print("roundui hit x=" + this.cursor.x + " :  cursor y=" + this.cursor.y + " --> " + uiobj.name)
          this.cursor.w = roundui.bounds.w+4
          this.cursor.h = roundui.bounds.h+4
          this.select = roundui
          ishit.cursor = true
          hit = true
          if this.events.onHitUI and this.events.onHitUI.type == "function" then
            (this.events.onHitUI)(lx, ly, uiobj)
          end
        end
      else
        
      end
    end
    
    //---start mouse/touch operation check
    if not hit then  
      local msx = 0
      local msy = 0
      local ismove = false
      if mouse.pressed then
        msx = round(mouse.x)
        msy = round(mouse.y)
        ismove = true
      elsif touch.touching then
        msx = round(touch.touches[0].x)
        msy = round(touch.touches[0].y)
        ismove = true
      end
      if ismove then
        for r = 0 to this.map.length-1
          for c = 0 to this.map[r].length-1
            local rcui = null
            if this.map[r][c].type == "string" then
              rcui = this.uimanager.ui[this.uigroup][this.map[r][c]]
            elsif this.map[r][c].type == "object" then
              rcui = this.map[r][c]
            end
            if rcui then
              if rcui.checkTouchArea(msx, msy) then
                if this.select.name == rcui.name then
                  ishit.mouse_already = true
                end
                this.cursor.x = c
                this.cursor.y = r
                this.cursor.w = rcui.bounds.w+4
                this.cursor.h = rcui.bounds.h+4
                this.select = rcui
                ishit.mouse_hit = true
                if this.events.onHitUI and this.events.onHitUI.type == "function" then
                  (this.events.onHitUI)(lx, ly, uiobj)
                end
              end
            end
          end
        end
      end
      
    end
    return ishit
  end
  update = function()
    this.now = system.time()
    if this.enable_cursor then
      if this.now - this.lasttime >= 15 * this.framedur then
        this.lasttime = this.now
        this.cursorAlpha += this.cursorAlphaVelocity
        if this.cursorAlpha < 0 then
          this.cursorAlphaVelocity = 0.25
        elsif this.cursorAlpha > 1.0 then
          this.cursorAlphaVelocity = -0.25
        end 
      end
    end
    //---update ui
    if this.select then
      if this.keymanager.checkDecide() then
        
        if (
            (this.select.uitype == TYPELIST.CHECKBOX) or 
            (this.select.uitype == TYPELIST.RADIOBUTTON)
          ) then
          this.select.check()
        elsif this.select.uitype == TYPELIST.BUTTON then
          this.select.push()
        end
      end
    end
  end
  draw = function()
    if this.enable_cursor then
      if this.select != 0 then
        screen.setDrawAnchor(this.select.anchorx,this.select.anchory)
        screen.setAlpha(this.cursorAlpha)
        screen.drawRect(this.select.bounds.x-2, this.select.bounds.y+2, this.cursor.w, this.cursor.h, this.cursorColor)
      end
    end
  end
end