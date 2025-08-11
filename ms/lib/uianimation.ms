//==============================================================
GUIAnimationImage = class extends GameUI
  LOOPTYPE = object
    TOBEGIN = 1
    NOLOOP = 0
    REVERSE = -1
  end
  constructor = function(bnd)
    super(TYPELIST.ANIMATIONIMAGE, bnd)
    
    /**
    *
    * @type {Array<GUIImage>} list of GUIImage
    */
    this.imagelist = []
    this.isManualAnimation = true
    this.curImage = 0
    /**
    *
    * @type {LOOPTYPE} 
    */
    this.looptype = LOOPTYPE.NOLOOP
    this.loopv = 1
    this.animationPeriod = round(system.fps * 0.5)
  end
  loadJSON = function(data)
    super(data)
    if data.include("isCutSprite") then this.isCutSprite = data.isCutSprite end
    if data.include("looptype") then this.looptype = data.looptype end
    if data.include("animationPeriod") then this.animationPeriod = data.animationPeriod end
    if data.include("imagelist") then
      local lst = []
      for img in data.imagelist
        local imgobj = new GUIImage(this.bounds, "")
        imgobj.loadJSON(img)
        lst.push(imgobj)
      end
      this.addImage(lst)
    end
  end
  addImage = function(img)
    if img.type == "list" then
      for l in img
        l.bounds.x = this.bounds.x
        l.bounds.y = this.bounds.y
        this.imagelist.push(l)
      end
    elsif img.type == "object" then
      img.bounds.x = this.bounds.x
      img.bounds.y = this.bounds.y
      this.imagelist.push(img)
    end
  end
  removeImage = function (index)
    this.imagelist.removeAt(index)
  end
  play = function ()
    this.curImage = 0
    this.isManualAnimation = true
  end
  stop = function()
    this.isManualAnimation = false
  end
  playToggle = function()
    this.isManualAnimation = not this.isManualAnimation
    return this.isManualAnimation
  end
  update = function()
    super()
    if this.isManualAnimation  then
      if this.fps.each(this.animationPeriod) then
        this.curImage += this.loopv
        
        //---reach max
        if this.imagelist.length-1 < this.curImage then
          if this.looptype == LOOPTYPE.TOBEGIN then
            this.curImage = 0
            this.loopv = 1
          elsif this.looptype == LOOPTYPE.REVERSE then
            this.loopv = -1
          end
        elsif this.curImage < 0 then
          //---reach min
          this.curImage = 0
          this.loopv = 1
        end
      end
    end
    this.imagelist[this.curImage].update()
  end
  draw = function()
    super()
    this.imagelist[this.curImage].draw()
    
  end
end

//==============================================================
GUIAnimationImageManager = class extends GameUI
  constructor = function (bnd)
    super(TYPELIST.ANIMATIONMANAGER, bnd)
    /**
    *
    * @type {Object{String: GUIAnimationImage}}
    *
    */
    this.moveDict = object end
    this.curMove = ""
  end
  loadJSON = function(data)
    super(data)
    if data.include("moveDict") then
      for md in data.moveDict
        this.addAnimation(md)
        this.moveDict[md].loadJSON(data.moveDict[md])
      end
    end
    if data.include("curMove") then this.curMove = data.curMove end
  end
  cur = function ()
    return this.moveDict[this.curMove]
  end
  setCur = function (name)
    if this.moveDict.include(name) then
      this.curMove = name
      return true
    else
      return false
    end
  end
  addAnimation = function(name)
    this.moveDict[name] = new GUIAnimationImage(this.bounds)
    return this.moveDict[name]
  end
  removeAnimation = function (name)
    if this.moveDict.include(name) then
      delete this.moveDict[name]
    end
  end
  update = function()
    super()
    if this.moveDict.include(this.curMove) then
      this.moveDict[this.curMove].update()
    end
  end
  draw = function ()
    super()
    if this.moveDict.include(this.curMove) then
      this.moveDict[this.curMove].draw()
    end
  end
end