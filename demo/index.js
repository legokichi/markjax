// Generated by CoffeeScript 1.7.1
var RootComponent;

window.addEventListener("DOMContentLoaded", function(ev) {
  return m.mount(document.body, RootComponent);
});

RootComponent = {
  controller: function(data) {
    var CodeMirrorMC, PreviewMC;
    CodeMirrorMC = {
      onchange: function(cm, cmev) {
        var body, err;
        PreviewMC.head("<link rel='stylesheet' href='../thirdparty/github-markdown/github-markdown.css' />");
        m.startComputation();
        try {
          console.log(body = marked(this.value()));
          PreviewMC.body("<div class='markdown-body'>" + body + "</div>");
          return m.endComputation();
        } catch (_error) {
          err = _error;
          return console.error(err);
        }
      },
      value: m.prop(""),
      option: m.prop({
        enableCodeMirror: true
      }),
      config: m.prop({
        mode: "markdown",
        tabMode: "indent",
        tabSize: 2,
        theme: 'solarized dark',
        autoCloseTags: true,
        lineNumbers: true,
        matchBrackets: true,
        autoCloseBrackets: true,
        showCursorWhenSelecting: true,
        extraKeys: {
          "Tab": function(cm) {
            return CodeMirror.commands[(cm.getSelection().length ? "indentMore" : "insertSoftTab")](cm);
          },
          "Shift-Tab": "indentLess"
        }
      })
    };
    PreviewMC = {
      head: m.prop(""),
      body: m.prop("")
    };
    return {
      PreviewMC: PreviewMC,
      CodeMirrorMC: CodeMirrorMC
    };
  },
  view: function(ctrl) {
    var borderBox;
    borderBox = "box-sizing: border-box;\nmargin: 0px;\nborder: none;\npadding: 0px;\nwidth: 100%;\nheight: 100%;";
    return [
      m("style", {}, "html{position: absolute;}\nbody{position: relative;}\nhtml,body{" + borderBox + "}"), m("div", {
        style: "display: flex;" + borderBox
      }, [
        m("section", {
          style: borderBox
        }, [m.component(CodeMirrorComponent, ctrl.CodeMirrorMC)]), m("section", {
          style: borderBox
        }, [m.component(PreviewComponent, ctrl.PreviewMC)])
      ])
    ];
  }
};

marked.setOptions({
  renderer: new marked.Renderer(),
  gfm: true,
  tables: true,
  breaks: false,
  pedantic: false,
  sanitize: false,
  smartLists: false,
  smartypants: false
});
