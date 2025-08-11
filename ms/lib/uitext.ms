GUITextMessage = class extends GUIContainer
  FORWARDTYPE = object
    LINE = 0
    CHAR = 1
  end
  constructor = function(bnd, textlst = [], font = 0, fontcolor)
    super(bnd, font, bgcolor)
    this.uitype = TYPELIST.TEXTMESSAGE
    this.messages = textlst
    this.alltext = new GUIText("", bnd, font, fontcolor)
    this.forwardText = []
    this.showtext = new GUIText("", bnd, font, fontcolor)
    this.showtext.setAnchor(-1,1)
    
    this.textforwarding = FORWARDTYPE.CHAR
    this.drawtime = round(system.fps * 0.1)
    this.curmsg_index = -1
    this.curfdtext_index = 0
    this.is_forwarding = false
  end
  loadJSON = function (data)
    super(data)
    
    if data.include("color") then
      this.alltext.color1 = data.color
      this.showtext.color1 = data.color
    end
    if data.include("textforwarding") then this.textforwarding = data.textforwarding end
    if data.include("messages") then this.messages = data.messages end
    if data.include("drawtime") then this.drawtime = data.drawtime end
    
  end
  setMessageList = function (msgs)
    this.messages = msgs
    this.goFirst()
  end
  goFirst = function(is_cleartext = false)
    this.curmsg_index = -1
    this.is_forwarding = false
    if is_cleartext then
      this.showtext.clear()
    end
    this.curfdtext_index = -1
  end
  goForward = function (dir = 1)
    this.curmsg_index += dir
    if (this.curmsg_index >= this.messages.length) or (this.curmsg_index < 0) then
      return
    end
    this.alltext.setText(this.messages[this.curmsg_index])
    //print(this.alltext.text)
    this.forwardText = this.alltext.wrapper.splitText(this.alltext.text)
    //print("   " + this.forwardText)
    this.curfdtext_index = -1
    this.showtext.clear()
    this.is_forwarding = true
  end
  update = function()
    super()
    if this.fps.each(this.drawtime) and this.is_forwarding then
      this.curfdtext_index += 1
      if (this.curfdtext_index <= this.forwardText.length-1) then
        //print(this.showtext.text + this.forwardText[this.curfdtext_index])
        this.showtext.setText(this.showtext.text + this.forwardText[this.curfdtext_index])
      else
        this.is_forwarding = false
      end
    end
  end
  draw = function()
    super()
    this.showtext.draw()
  end
end