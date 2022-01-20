JsOsaDAS1.001.00bplist00�Vscript_%app = Application.currentApplication()
app.includeStandardAdditions = true

function confirm(text) {
  try {
    app.displayDialog(text)
    return true
  } catch (e) {
    return false
  }
}

function prompt(text, defaultAnswer) {
  var options = { defaultAnswer: defaultAnswer || '' }
  try {
    return app.displayDialog(text, options).textReturned
  } catch (e) {
    return null
  }
}

function alert(text, informationalText) {
  var options = { }
  if (informationalText) options.message = informationalText
  app.displayAlert(text, options)
}                              ; jscr  ��ޭ