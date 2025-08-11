KeyElement = class
  constructor = function(ctrler, keyname,action)
    //---k - keyboard, g - gamepad
    this.ctrlname = ctrler
    this.keyname = keyname
    //---d - down, p - press, r - release
    this.action = action
  end
end
KeyManager = class 
  constructor = function(parent)
    this.parent = parent
    this.key_decide = [new KeyElement("k","ENTER","r")]
    this.key_cancel = [new KeyElement("k","ESCAPE","r")]
    this.key_up = [new KeyElement("k","UP","d"),new KeyElement("k","W","d"),new KeyElement("g","DPAD_UP","d")]
    this.key_down = [new KeyElement("k","DOWN","d"),new KeyElement("k","S","d"),new KeyElement("g","DPAD_DOWN","d")]
    this.key_left = [new KeyElement("k","LEFT","d"),new KeyElement("k","A","d"),new KeyElement("g","DPAD_LEFT","d")]
    this.key_right = [new KeyElement("k","RIGHT","d"),new KeyElement("k","D","d"),new KeyElement("g","DPAD_RIGHT","d")]
    /**
    * custom keys
    * @type {{String: List}} 
    * 
    */
    this.key_custom = object end
  end
  _checkBody = function(key, action = "")
    local ret = false
    local daction = key.action
    if action != "" then
      daction = action
    end
    if key.ctrlname == "k" then
      if daction == "d" then
        ret = keyboard[key.keyname]
      elsif daction == "p" then
        ret = keyboard.press[key.keyname]
      elsif daction == "r" then
        ret = keyboard.release[key.keyname]
      end
    elsif key.ctrlname == "g" then
      if daction == "d" then
        ret = gamepad[key.keyname]
      elsif daction == "p" then
        ret = gamepad.press[key.keyname]
      elsif daction == "r" then
        ret = gamepad.release[key.keyname]
      end
    end
    return ret
  end
  _keyBody = function(lst, action = "") 
    local ret = false
    for k in lst
      if this._checkBody(k, action) then
        ret = true
        break
      end
    end
    return ret
  end
  addCustomKey = function (name, lst)
    this.key_custom[name] = lst
  end
  removeCustomKey = function (name)
    delete this.key_custom[name]
  end
  is_up = function(action = "")
    return this._keyBody(this.key_up,action)
  end
  is_down = function(action = "")
    return this._keyBody(this.key_down,action)
  end
  is_left = function(action = "")
    return this._keyBody(this.key_left,action)
  end
  is_right = function(action = "")
    return this._keyBody(this.key_right,action)
  end
  checkDecide = function(action = "")
    return this._keyBody(this.key_decide,action)
  end
  checkCancel = function(action = "")
    return this._keyBody(this.key_cancel,action)
  end
  checkCustom = function(name, action = "")
    return this._keyBody(this.key_custom[name],action)
  end
  update = function ()
    local dir = object
      x = this.is_right() - this.is_left()
      y = this.is_down() - this.is_up()
    end
    return dir
  end
end