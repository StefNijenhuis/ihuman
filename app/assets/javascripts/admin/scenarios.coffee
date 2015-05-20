ready = ->

  class Scenario
    container = $("#scenario-builder")
    id = 0;

    constructor: (@obj, @briefing) ->
      this.node("briefing", null, @briefing)

    node: (@type, @parent, @content) ->
     switch @type
        when "briefing"
          if !@obj.briefing # Check if briefing exists
            @obj['briefing'] = {
              id: id++;
              type:"briefing",
              parent:null,
              content:@content,
              children:[]
            };
          else
            obj.briefing.content = @content;
        when "question"
          if !@id = null
            parent = this.getObjects(@parent)

            child = {
              id: id++;
              type:"question",
              parent:@parent,
              content:@content,
              children:[]
            };

            parent.children.push child

    getObjects: (val, obj) ->
      obj = (if typeof obj isnt "undefined" then obj else @obj)
      key = "id"
      objects = []
      for i of obj
        continue  unless obj.hasOwnProperty(i)
        if typeof obj[i] is "object"
          objects = objects.concat(this.getObjects(val, obj[i]))
        else
          objects.push obj  if i is key and obj[key] is val
          break
      objects[0]

    save: ->
      JSON.stringify(@obj);

    load: (obj) ->
      @obj = JSON.parse( obj );

    generate: (obj) ->
      obj = (if typeof obj isnt "undefined" then obj else @obj)

      for i of obj.briefing.children
        obj.briefing.children[i]

  window.scenario = new Scenario(window.obj = {}, "Dit is de briefing");

  #scenario.node("question", null, "test");

$(document).ready(ready)
$(document).on('page:load', ready)
