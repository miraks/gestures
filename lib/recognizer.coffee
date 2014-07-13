_ = require 'underscore-plus'

module.exports =
class Recognizer
  constructor: (@points) ->

  recognize: ->
    directions = [0...@points.length - 1].map (n) =>
      @direction @points[n..n + 1]...
    _.unique(directions).join('')

  direction: (p1, p2) ->
    angle = @angle p1, p2
    switch
      when -45 <= angle < 45 then 'R'
      when 45 <= angle < 135 then 'D'
      when -180 <= angle < -135 or 135 <= angle < 180 then 'L'
      when -135 <= angle < 45 then 'U'

  angle: (p1, p2) ->
    Math.atan2(p2.y - p1.y, p2.x - p1.x) * 180 / Math.PI
