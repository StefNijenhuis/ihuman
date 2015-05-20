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
            if @parent is 0
              parent = @obj.briefing
            else
              parent = this.getParent(@parent, @obj.briefing)
              parent = parent[0]

            child = {
              id: id++;
              type:"question",
              parent:@parent,
              content:@content,
              children:[]
            };

            parent.children.push child

    getParent: (val, obj) ->
      obj = (if typeof obj isnt "undefined" then obj else @obj)
      key = "id"
      object = []

      for child of obj.children # for each item in children

        if obj.children[child].id is val # check if item.id matches val
          object.push obj.children[child] # if it does, push it into the object array
          break # and stop the for loop

        if obj.children[child].children # if object has children
          object = this.getParent(val, obj.children[child]) # then loop over these as well
          if object # and if anything returns
            break # stop the for loop

      object # and finally return the object

    save: ->
      JSON.stringify(@obj);

    load: (obj) ->
      @obj = JSON.parse( obj );

    generate: (obj) ->
      obj = (if typeof obj isnt "undefined" then obj else @obj)

      # Briefing

      # Children

    children: (obj, element) ->
      for child of obj.children
        el = $("") # TODO: create dom element
        if obj.children[child].children
          this.child(obj.children[child], el)


  window.scenario = new Scenario(window.obj = {}, "Dit is de briefing");

  scenario.node("question", 0, "question 1")
  scenario.node("question", 1, "question 2")
  scenario.node("question", 2, "question 3")
  scenario.node("question", 3, "question 4")
  scenario.node("question", 4, "question 5")

  #scenario.node("question", null, "test");

$(document).ready(ready)
$(document).on('page:load', ready)
