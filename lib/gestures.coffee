GesturesView = require './gestures-view'
Commander = require './commander'

module.exports =
  views: []

  activate: (state) ->
    atom.workspaceView.eachEditorView (paneView) =>
      view = new GesturesView paneView
      @views.push view

    Commander.activate()

  deactivate: ->
    @views.forEach (view) -> view.destroy()
    @views = []
