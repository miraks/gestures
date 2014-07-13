class Commander
  gestures:
    U: 'prevTab'
    D: 'nextTab'
    DR: 'closeTab'
    DL: 'undoCloseTab'

  activate: ->
    atom.workspace.getPanes().forEach (pane) =>
      pane.on 'item-removed', (item, index) =>
        @lastRemovedItem = item
        @lastRemovedItemIndex = index

  command: (gesture) ->
    @[@gestures[gesture]]?()

  prevTab: ->
    atom.workspace.activePane.activatePreviousItem()

  nextTab: ->
    atom.workspace.activePane.activateNextItem()

  closeTab: ->
    pane = atom.workspace.activePane
    pane.removeItem pane.activeItem

  undoCloseTab: ->
    atom.workspace.activePane.addItem @lastRemovedItem, @lastRemovedItemIndex
    atom.workspace.activePane.activateItem @lastRemovedItem

module.exports = new Commander
