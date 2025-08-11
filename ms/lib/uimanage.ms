TYPELIST = object
  TEXT = 0
  IMAGE = 1
  CHECKBOX = 2
  RADIOBUTTON = 3
  RECT = 4
  BUTTON = 5
  SLIDER = 6
  DIALOG = 7
  CONTAINER = 8
  SCROLLAREA = 9
  LISTBOX = 10
  ANIMATIONIMAGE = 11
  ANIMATIONMANAGER = 12
  TEXTMESSAGE = 13
end
GameUIManager = class
  constructor = function(parent)
    /*
    * @type {GUISystem}
    */
    this.parent = parent
    /**
    *
    * @type {Object}
    * ui.group.element
    * 
    */
    this.ui = object 
      default = object end
    end
    //---start link
    //GameUI.referlist = this.ui
  end
  /*
  * generate UI controls from JSON
  *
  * @return { [{data:Object, ui: Object, is_after:Boolean}] }
  */
  loadFromJSON = function (data) 
    /*
      Data specification:
      {
        "controls" : [
          {
            "id" : "hogehoe", data format only ID (can be used for any purpose)
            "uitype" : 0, //TYPELIST
            "uigroup" : "hoge",
            //---below is each ui's properties
            "text" : "abc def",
            "bounds" : {
              "x" : 0, "y": 10,
              "w" : 75, "h" : 25
            },
            ...
          }
        ]
      }
    */
    local defbnd = new Bounds()
    local ret = []
    local tmpfont = this.parent.fonts[0]
    if data then
      for dataui in data
        if dataui.include("uitype") then
          local retitem = object
            data = null
            ui = null
            is_after = false
          end
          //print("===> dataui===>")
          //print(dataui)
          local tmpui = null
          if dataui.uitype == TYPELIST.TEXT then
            tmpui = new GUIText("",defbnd, tmpfont)
            tmpui.loadJSON(dataui)
          elsif dataui.uitype == TYPELIST.IMAGE then
            tmpui = new GUIImage(defbnd,"")
            tmpui.loadJSON(dataui)
          elsif dataui.uitype == TYPELIST.ANIMATIONIMAGE then
            tmpui = new GUIAnimationImage(defbnd)
            tmpui.loadJSON(dataui)
            
            retitem.is_after = true
          elsif dataui.uitype == TYPELIST.ANIMATIONMANAGER then
            tmpui = new GUIAnimationImageManager(defbnd)
            tmpui.loadJSON(dataui)
            
            retitem.is_after = true
          elsif dataui.uitype == TYPELIST.CHECKBOX then
            tmpui = new GUICheckbox("",defbnd)
            tmpui.font = tmpfont
            tmpui.text.font = tmpfont
            tmpui.loadJSON(dataui)
          elsif dataui.uitype == TYPELIST.RADIOBUTTON then
            tmpui = new GUIRadiobutton("",defbnd)
            tmpui.font = tmpfont
            tmpui.text.font = tmpfont
            tmpui.loadJSON(dataui)
          elsif dataui.uitype == TYPELIST.RECT then
            tmpui = new GUIRect(defbnd,"#FFF")
            tmpui.loadJSON(dataui)
          elsif dataui.uitype == TYPELIST.BUTTON then
            tmpui = new GUIButton("",defbnd)
            tmpui.font = tmpfont
            tmpui.text.font = tmpfont
            tmpui.loadJSON(dataui)
          elsif dataui.uitype == TYPELIST.SLIDER then
            tmpui = new GUISlider(defbnd, 0, 0, 0, 0)
            tmpui.font = tmpfont
            tmpui.loadJSON(dataui)
          elsif dataui.uitype == TYPELIST.DIALOG then
            tmpui = new GUIDialog(defbnd,GUIDialog.BTNLIST.NOSETUP)
            tmpui.font = tmpfont
            tmpui.loadJSON(dataui)
            if dataui.include("contents") then
              dlgcon = this.loadFromJSON(dataui.contents)
              for dc in dlgcon
                tmpui.addContents(dc.ui)
              end
            end
          elsif dataui.uitype == TYPELIST.CONTAINER then
            tmpui = new GUIContainer(defbnd,tmpfont)
            tmpui.loadJSON(dataui)
            if dataui.include("contents") then
              contcon = this.loadFromJSON(dataui.contents)
              for dc in contcon
                tmpui.addContents(dc.ui)
              end
            end
          elsif dataui.uitype == TYPELIST.SCROLLAREA then
            tmpui = new GUIScrollArea(defbnd,tmpfont)
            tmpui.loadJSON(dataui)
            if dataui.include("contents") then
              contcon = this.loadFromJSON(dataui.contents)
              for dc in contcon
                tmpui.addContents(dc.ui)
              end
            end
          elsif dataui.uitype == TYPELIST.LISTBOX then
            tmpui = new GUIListBox(defbnd,tmpfont)
            tmpui.loadJSON(dataui)
          elsif dataui.uitype == TYPELIST.TEXTMESSAGE then
            tmpui = new GUITextMessage(defbnd,[],tmpfont)
            tmpui.loadJSON(dataui)
          end
          //---finally
          if tmpui != null then
            //this.add(tmpui, if dataui.include("uigroup") then dataui.uigroup else "default" end)
            retitem.data = dataui
            retitem.ui = tmpui
            ret.push(retitem)
          end
        end
      end
    end
    return ret
  end
  addFromJSON = function(data)
    if data.include("controls") then
      local lst = this.loadFromJSON(data.controls)
      if lst == null then
        return
      end
      for it in lst
        //print("---it---")
        //print(it.ui)
        this.add(
          it.ui, 
          if it.data.include("uigroup") then it.data.uigroup else "default" end,
          if it.data.include("name") then it.data.name else "" end
        )
      end
    end
  end
  addGridMapFromJSON = function(data)
    if data.include("gridmap") then
      return data.gridmap
    else
      return []
    end
  end
  getGroupCount = function()
    local keys = this.ui.getKeys()
    local cnt = keys.length
    return cnt
  end
  getCount = function(group = "default")
    local cnt = 0
    for e in this.ui[group]
      cnt += 1
    end
    return cnt
  end
  g = function (group)
    return this.ui[group]
  end
  getObject = function(name, group = "default")
    local ret = null
    if this.ui[group].include(name) then
      ret = this.ui[group][name]
    else
      for r in this.ui[group]
        if (
           (this.ui[group][r].uitype == TYPELIST.SCROLLAREA) or
           (this.ui[group][r].uitype == TYPELIST.CONTAINER) 
        )
        then
          for lcon in this.ui[group][r].contents
            if lcon.name == name then
              ret = lcon
              break
            end
          end
          /*
          if this.ui[group][r].contents.include(name) then
            ret = this.ui[group][r].contents[name]
          end
          */
        end
      end
    end
    return ret
  end
  add = function(ui, group = "default", name = "")
    //print("ui="+ui.name)
    //print("  group="+group)
    //print("  name="+name)
    ui.uigroup = group
    ui.referlist = this.ui[group]
    ui.parent = this
    ui.keyman = this.parent.keymanager
    if name == "" then
      this.ui[group][ui.name] = ui
    else
      this.ui[group][name] = ui
    end
  end
  addGroup = function (group)
    this.ui[group] = object end
  end
  rename = function(name, newname, group = "default") 
    if name == "" then
      return
    end
    if this.ui[group].include(newname) then
      print("warning:"+newname+" is already found.")
      return
    end
    this.ui[group][newname] = this.ui[group][name]
    this.ui[group][newname].name = newname
    delete this.ui[group][name]
  end
  remove = function (name, group = "default")
    delete this.ui[group][name]
  end
  removeGroup = function(group)
    if group == "" then
      return false
    end
    if group == "default" then
      print("warning: can't remove default group.")
      return false
    end
    delete this.ui[group]
    return true
  end
  getGroupItems = function(grpname)
    local ret = []
    for u in this.ui
      if this.ui[u].uigroup == grpname then
        ret.push(this.ui[u])
      end
    end
    return ret
  end
  update = function(group)
    if group != "" then
      for elem in this.ui[group]
        this.ui[group][elem].update()
      end
    end
  end
  draw = function(group)
    if group != "" then
      for elem in this.ui[group]
        if this.ui[group][elem] and this.ui[group][elem].uitype != TYPELIST.DIALOG then
          this.ui[group][elem].draw()
        end
      end
      //---prioritize dialog 
      for elem in this.ui[group]
        if this.ui[group][elem] and this.ui[group][elem].uitype == TYPELIST.DIALOG then
          this.ui[group][elem].draw()
        end
      end
    end
  end
end