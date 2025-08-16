/**
* Bounds version of screen.drawSpritePart
*
* @param {String} imagename
* @param {Bounds} srcbnd
* @param {Bounds} destbnd
*
*/
drawSpritePartBounds = function(imagename, srcbnd, destbnd)
  screen.drawSpritePart(imagename, 
    srcbnd.x, srcbnd.y, srcbnd.w, srcbnd.h,
    destbnd.x, destbnd.y, destbnd.w, destbnd.h
  )
end

// in operator ... example Python's if "name" in listvar:
Object.include = function (name)
  local ret = false
  for e in this
    if e == name then
      ret = true
      break
    end
  end
  return ret
end
Object.exclude = function (name)
  local ret = true
  for e in this
    if e == name then
      ret = false
      break
    end
  end
  return ret
end
Object.getKey = function (val)
  local ret = ""
  for e in this
    if this[e] == val then
      ret = e
      break
    end
  end
  return ret
end
Object.getKeys = function()
  local ret = []
  for k in this
    ret.push(k)
  end
  return ret
end
List.clear = function()
  while this.length > 0
    this.pop()
  end
end

/**
* check value is into range
* @param {Number} minval
* @param {Number} maxval
* @return {Boolean} 
*/
Number.checkRange = function (minval, maxval) 
  if (minval <= this) and (maxval >= this) then
    return true
  else
    return false
  end
end


Bounds = class
  constructor = function (x = 0, y = 0, w = 0, h = 0)
    if x.type == "object" then
      this.x = x.x
      this.y = x.y
      this.w = x.w
      this.h = x.h
    else
      this.x = x
      this.y = y
      this.w = w
      this.h = h
    end
  end
  zero = function()
    return new Bounds()
  end
  
end
GUIFPS = class
  constructor = function()
    this.framedur = 1000 / system.fps
    this.lasttime = system.time()
    this.now = this.lasttime
  end
  each = function(val)
    if (this.now - this.lasttime) >= val * this.framedur then
      this.lasttime = this.now
      return true
    else
      return false
    end
  end
  update = function()
    this.now = system.time()
  end
end
GUISystem = class 
  constructor = function ()
    this.left = round(-screen.width/2)
    this.right = round(screen.width/2)
    this.top = round(screen.height/2)
    this.bottom = round(-screen.height/2)
    this.oldscreen = object
      width = screen.width
      height = screen.height
    end
    this.unit = 8
    this.unitRange = object
      minx = round(-screen.width/2) / this.unit
      miny = round(-screen.height/2) / this.unit
      maxx = round(screen.width/2) / this.unit
      maxy = round(screen.height/2) / this.unit
      countx = round(screen.width) / this.unit
      county = round(screen.height) / this.unit
    end
    this.fps = new GUIFPS()
    this.fonts = []
    this.uimanager = new GameUIManager(this)
    this.keymanager = new KeyManager(this)
    this.callback = object
      onresize = null
    end
  end
  setUnit = function(unit)
    this.unit = unit
    this.unitRange.minx = round(-screen.width/2) / this.unit
    this.unitRange.miny = round(-screen.height/2) / this.unit
    this.unitRange.maxx = round(screen.width/2) / this.unit
    this.unitRange.maxy = round(screen.height/2) / this.unit
    this.unitRange.countx = round(screen.width) / this.unit
    this.unitRange.county = round(screen.height) / this.unit
  end
  pos = function(num)
    return num * this.unit
  end
  addFont = function (name,size)
    this.fonts.push(new GameFont(name,size))
    return this.fonts[this.fonts.length-1]
  end

  update = function()
    this.fps.update()
    local keyret = this.keymanager.update()
    if (screen.width != this.oldscreen.width) or 
      (screen.height != this.oldscreen.height)
    then
      if this.callback.onresize != null then
        (this.callback.onresize)(screen.width, screen.height)
      end
    end
    this.oldscreen.width = screen.width
    this.oldscreen.height = screen.height
    return keyret
  end
  
  uiupdate = function (grp = "default")
    this.uimanager.update(grp)
  end
  uidraw = function (grp = "default")
    this.uimanager.draw(grp)
  end
end

GameFont = class
  constructor = function(name, size)
    this.name = name
    this.size = size
  end
end
