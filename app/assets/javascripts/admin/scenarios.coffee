ready = ->

  class Scenario
    container = $("#scenario-builder")

    constructor: (@briefing) ->
      this.node("briefing", null, @briefing)

    node: (@type, @parent, @content) ->
     switch @type
        when "briefing"
          container.append('<div class="node">' + @content + '</div>')
        when "question"
          container.append('<div class="node">' + @content + '</div>')

  scenario = new Scenario("Dit is de briefing");
  scenario.node("question", null, "test");

$(document).ready(ready)
$(document).on('page:load', ready)
