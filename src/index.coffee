## main
$ ->
  m.mount(document.body, RootComponent)

RootComponent =
  controller: (data)->
    CodeMirrorController =
      onchange: (cm, cmev)->
        PreviewController.head("<link rel='stylesheet' href='../thirdparty/github-markdown/github-markdown.css' />")
        PreviewController.body("<div class='markdown-body'>#{marked(@value())}</div>")
      changeConfig: (key, val)->
        config = @config()
        config[key] = val
        @config(config)
      value: m.prop("")
      config: m.prop
        enableCodeMirror: true
        CodeMirrorConfig:
          mode: "markdown"
          tabMode: "indent"
          tabSize: 2
          theme: 'solarized dark'
          autoCloseTags : true
          lineNumbers: true
          matchBrackets: true
          autoCloseBrackets: true
          showCursorWhenSelecting: true
          extraKeys:
            "Tab": (cm)->
              CodeMirror.commands[(
                if cm.getSelection().length
                then "indentMore"
                else "insertSoftTab"
              )](cm)
            "Shift-Tab": "indentLess"
    PreviewController =
      head: m.prop("")
      body: m.prop("")
    {CodeMirrorController, PreviewController}
  view: (ctrl)->
    m("div", {id: "box"}, [
      m("section", {id: "box-editor"}, [
        m.component(CodeMirrorComponent, ctrl.CodeMirrorController)
      ])
      m("section", {id: "box-box-preview"}, [
        m.component(PreviewComponent, ctrl.PreviewController)
      ])
    ])

PreviewComponent =
  controller: (attrs)-> {}
  view: (ctrl, attrs)->
    m("iframe", {
      id: "box-preview-iframe",
      config: PreviewComponent.config(attrs)
    }, [])
  head: null
  body: null
  config: (attrs)-> (elm, isInitialized, ctx, vdom)=>
    if !isInitialized
      m.mount(elm.contentDocument.head, {
        view: (_ctrl, _attrs)->
          console.log code = templateConverter.Template(attrs.head())
          new Function("ctrl", "attrs", "return #{code}")(_ctrl, _attrs)
      })
      m.mount(elm.contentDocument.body, {
        view: (_ctrl, _attrs)->
          console.log code = templateConverter.Template(attrs.body())
          new Function("ctrl", "attrs", "return #{code}")(_ctrl, _attrs)
      })

CodeMirrorComponent =
  controller: (attrs)-> {}
  view: (ctrl, attrs)->
    m("textarea", {
      id: "box-editor-textarea", wrap: "off",
      config: CodeMirrorComponent.config(attrs)
      onkeydown: -> # when textearea mode
        m.withAttr("value", attrs.value).apply(this, arguments)
        attrs.onchange.apply(attrs, arguments)
    }, attrs.value())
  cm: null
  docs: []
  config: (attrs)-> (elm, isInitialized, ctx, vdom)=>
    @initCM(attrs, elm) if !isInitialized
    if @detectChange(attrs.config())
      {CodeMirrorConfig, enableCodeMirror} = attrs.config()
      if enableCodeMirror
      then @initCM(attrs, elm)
      else @cm.toTextArea(); elm.focus()
      @cm.setOption(key, val) for key, val of CodeMirrorConfig
  prev: ""
  detectChange: (obj)->
    cur = JSON.stringify(obj)
    if cur isnt @prev
      @prev = cur
      true
    else false
  initCM: (attrs, elm)->
    @cm = CodeMirror.fromTextArea(elm)
    @docs.push(@cm.doc)
    @cm.setSize("100%", "100%")
    @cm.on "change", (cm, cmev)->
      m.startComputation()
      attrs.value(cm.doc.getValue())
      attrs.onchange() if typeof attrs.onchange is "function"
      m.endComputation()





## marked compiler setting
marked.setOptions
  renderer: new marked.Renderer()
  gfm: true
  tables: true
  breaks: false
  pedantic: false
  sanitize: false
  smartLists: false
  smartypants: false
