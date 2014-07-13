_ = require 'underscore-plus'
{View} = require 'atom'
Point = require './point'
Recognizer = require './recognizer'
Commander = require './commander'

module.exports =
class GesturesView extends View
  lineColor: 'green'
  permitMenu: false

  @content: ->
    @tag 'canvas', class: 'gestures'

  initialize: (@pane) ->
    @points = []

    @pane.append @
    @attr 'width', @pane.width()
    @attr 'height', @pane.height()
    @ctx = @element.getContext '2d'
    @ctx.strokeStyle = @lineColor

    @pane.on 'contextmenu', @onPaneContextMenu
    @on 'mousedown', _.throttle(@onMouseDown, 50)
    @on 'mouseup', @onMouseUp
    @on 'mousemove', @onMouseMove

  destroy: ->
    @off()

  drawLine: ->
    return if @isFirstPoint()
    [start, end] = _.last @points, 2
    @ctx.beginPath()
    @ctx.moveTo start.x, start.y
    @ctx.lineTo end.x, end.y
    @ctx.closePath()
    @ctx.stroke()

  isFirstPoint: ->
    @points.length is 1

  onMouseDown: (event) =>
    return if event.button isnt 2 or
      not @lastMenuCall? or event.timeStamp - @lastMenuCall > 300
    @permitMenu = true
    @hide()

  onMouseMove: (event) =>
    return @hide() unless event.button is 2
    point = new Point event.offsetX, event.offsetY
    @points.push point
    @drawLine()

  onMouseUp: (event) =>
    return if _.isEmpty @points
    @ctx.clearRect 0, 0, @width(), @height()
    @hide()
    gesture = new Recognizer(@points).recognize()
    Commander.command gesture
    @points = []

  onPaneContextMenu: (event) =>
    @lastMenuCall = event.timeStamp
    if @permitMenu
      @permitMenu = false
      true
    else
      @show()
      false
