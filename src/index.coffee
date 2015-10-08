
Preview = React.createClass
  render: ->
    JSXTransformer.exec(@props.body || "<div></div>")
$ ->
  iframeBody = document.getElementById("box-preview-iframe").contentDocument.body
  comp = React.render(React.createElement(Preview, {}), iframeBody)
  setInterval((()->
    date = new Date
    console.log body = """<div>
    <span>#{date.getHours()}</span>:
    <span>#{date.getMinutes()}</span>:
    <span>#{date.getSeconds()}</span>
    </div>"""
    React.render(React.createElement(Preview, {body}), iframeBody)
  ),1000)

## main
###
$ ->
  console.log edit = new Editor($("#box-editor")[0])
  console.log elm = React.createElement(Preview, {})
  console.log iframe = $("#box-preview-iframe")[0].contentDocument.body
  console.log comp = React.render(elm, iframe)
  edit.changeMode "markdown"
  edit.on "change", (text)->
    console.log body = "<body>"+marked(text)+"</body>"
    React.render(React.createElement(Preview, {body}), iframe)

Preview = React.createClass
  render: ->
    JSXTransformer.exec(@props.body || "<body></body>")
###

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


## React Root Component Class
class Component extends React.Component
  _.extend Component.prototype, React.DOM
  @element = -> React.createFactory(this).apply(this, arguments)






###
class Preview extends Component
  render: ->
    @iframe
      ref: 'htmlWrapper'
      html: @props.html
  componentDidMount: -> @renderFrameContents()
  componentDidUpdate: -> @renderFrameContents()
  _renderFrameContents: ->
    doc = React.findDOMNode(@).contentDocument
    if doc.readyState is 'complete'
      console.log "renderFrameContents", doc.readyState
      React.render(JSXTransformer.exec("<head>#{@props.head}</head>"), doc.head) if @props.head?
      React.render(JSXTransformer.exec("<body>#{@props.body}</body>"), doc.body) if @props.body?
    else setTimeout(@renderFrameContents, 0)
  renderFrameContents: ->
    current = @props.html
    if @_lastHtml isnt current
      @_lastHtml = current
      node = @refs.htmlWrapper.getDOMNode()
      console.log node
      node.contentDocument.body.innerHTML = current
      #node.style.height = node.contentWindow.document.body.scrollHeight + 'px'
      #node.style.width  = node.contentWindow.document.body.scrollWidth  + 'px'
  componentWillUnmount: ->
    React.unmountComponentAtNode(React.findDOMNode(@).contentDocument.head)
    React.unmountComponentAtNode(React.findDOMNode(@).contentDocument.body)

###


class Editor extends EventEmitter
  constructor: (@elm)->
    EventEmitter.call(this)
    @cm = CodeMirror.fromTextArea($(@elm).find("textarea")[0], @option)
    @cm.setSize("100%", "100%")
    @docs = []
    @docs.push @cm.doc
    @cm.on "change", => @emit "change", @cm.doc.getValue()
  changeMode: (mode)->
    @cm.setOption("mode", mode)
  option:
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
