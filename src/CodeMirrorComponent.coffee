###
Mithril CodeMirror component

m.component(CodeMirrorComponent, attrs)

attrs:
  onchange: ()->           # when attrs.value changed
  value: m.prop ""         # textarea value
  option: m.prop           # CodeMirrorComponent option
    enableCodeMirror: true # when it is false, change to textarea from codemirro
  config: m.prop {}        # CodeMirror config
###

CodeMirrorComponent =
  view: (ctrl, attrs)->
    m("textarea", {
      wrap: "off",
      style: "width:100%;height:100%;margin:none;box-sizing:border-box;"
      config: CodeMirrorComponent.config(attrs)
      onkeydown: -> # when textearea mode
        m.withAttr("value", attrs.value).apply(this, arguments)
        attrs.onchange.apply(attrs, arguments)
    }, attrs.value())

  prevConfig: {}
  prevOption: {}
  config: (attrs)-> (elm, isInitialized, ctx, vdom)=>
    cm = @initCM(attrs, elm) if !isInitialized

    if cm?
      config = attrs.config()
      keys = @collectChangeProp(@prevConfig, config)
      keys.forEach (key)=>
        console.log key, config[key]
        cm.setOption(key, config[key])
      @prevConfig = config

    option = attrs.option()
    keys = @collectChangeProp(@prevOption, option)
    keys.forEach (key)=>
      val = option[key]
      switch key
        when "enableCodeMirror"
          if val
          then cm = @initCM(attrs, elm) unless cm?
          else cm?.toTextArea(); elm.focus()
    @prevOption = option

  initCM: (attrs, elm)->
    cm = CodeMirror.fromTextArea(elm)
    cm.setSize("100%", "100%")
    cm.on "change", (cm, cmev)->
      m.startComputation() # emulate onkeydown event
      attrs.value(cm.doc.getValue())
      attrs.onchange() if typeof attrs.onchange is "function"
      m.endComputation() # force render
    cm

  collectChangeProp: (prev, curr)->
    rm = Object.keys(prev).filter (key)->
      prev[key] isnt curr[key]
    add = Object.keys(curr).filter (key)->
      curr[key] isnt prev[key]
    [].concat add, rm
