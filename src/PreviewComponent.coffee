###
Mithril Preview component

m.component(PreviewComponent, attrs)

attrs:
  head: m.prop "" # head element inner HTMLString
  body: m.prop "" # body element inner HTMLString

require("templateConverter.js")
###

PreviewComponent =
  view: (ctrl, attrs)->
    m("iframe", {
      style: "width:100%;height:100%;margin:none;box-sizing:border-box;"
      config: PreviewComponent.config(attrs)
    }, [])
  config: (attrs)-> (elm, isInitialized, ctx, vdom)=>
    if !isInitialized
      m.mount(elm.contentDocument.head, {
        view: (_ctrl, _attrs)-> PreviewComponent.toVDOM(attrs.head())
      })
      m.mount(elm.contentDocument.body, {
        view: (_ctrl, _attrs)-> PreviewComponent.toVDOM(attrs.body())
      })
  toVDOM: (html)->
    console.log code = templateConverter.Template(html)
    try
      console.log ret = new Function("return #{code}")()
    catch err
      console.error err
    ret
