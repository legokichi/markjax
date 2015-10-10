## main
window.addEventListener "DOMContentLoaded", (ev)->
  m.mount(document.body, RootComponent)

RootComponent =
  controller: (data)->
    CodeMirrorMC =
      onchange: (cm, cmev)->
        PreviewMC.head("<link rel='stylesheet' href='../thirdparty/github-markdown/github-markdown.css' />")
        m.startComputation()
        try
          console.log body = marked(@value())
          PreviewMC.body("<div class='markdown-body'>#{body}</div>")
          m.endComputation()
        catch err
          console.error err
      value: m.prop("")
      option: m.prop
        enableCodeMirror: true
      config: m.prop
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
    PreviewMC =
      head: m.prop("")
      body: m.prop("")
    {PreviewMC, CodeMirrorMC}
  view: (ctrl)->
    borderBox = """
      box-sizing: border-box;
      margin: 0px;
      border: none;
      padding: 0px;
      width: 100%;
      height: 100%;
    """
    [
      m("style", {}, """
        html{position: absolute;}
        body{position: relative;}
        html,body{#{borderBox}}
      """)
      m("div", {style: "display: flex;"+borderBox}, [
        m("section", {style: borderBox}, [
          m.component(CodeMirrorComponent, ctrl.CodeMirrorMC)
        ])
        m("section", {style: borderBox}, [
          m.component(PreviewComponent, ctrl.PreviewMC)
        ])
      ])
    ]






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
