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
      object = []

      for child of obj.children # for each item in children

        if obj.children[child].id is val # check if item.id matches val
          object.push obj.children[child] # if it does, push it into the object array
          break # and stop the for loop

        if obj.children[child].children # if object has children
          object = this.getParent(val, obj.children[child]) # then loop over these as well
          if object.length > 0 # and if anything returns
            break # stop the for loop

      object # and finally return the object

    save: ->
      JSON.stringify(@obj);

    load: (obj) ->
      @obj = JSON.parse( obj );

    generate: (obj) ->
      obj = (if typeof obj isnt "undefined" then obj else @obj)

      container.empty();

      # Briefing
      $("<ul><li id=\"node-#{obj.briefing.id}\"><fc-decision data-id=\"#{obj.briefing.id}\"><fc-add></fc-add><fc-remove></fc-remove>#{obj.briefing.content}</fc-decision><ul></ul></li></ul>").appendTo(container);

      # Children
      this.children(obj.briefing)

    children: (obj) ->
      for child of obj.children
        el = $("#node-#{obj.id}").children("ul")
        $("<li id=\"node-#{obj.children[child].id}\"><fc-decision data-id=\"#{obj.children[child].id}\"><fc-add></fc-add><fc-remove></fc-remove>#{obj.children[child].content}</fc-decision><ul></ul></li>").appendTo(el);

        if obj.children[child].children
          this.children(obj.children[child])

  $(document.body).on "click", "fc-decision", ->
    alert $(this).attr("data-id")

  window.scenario = new Scenario(window.obj = {}, "Dit is de briefing");

  scenario.node("question", 0, "question 1")
  scenario.node("question", 0, "question 2")
  scenario.node("question", 0, "question 3")
  scenario.node("question", 3, "question 2")
  scenario.node("question", 4, "question 2")
  scenario.generate()

  #scenario.node("question", null, "test");

jsPlumb.ready ->
  window.jsPlumb = jsPlumb.getInstance();

$(document).ready(ready)
$(document).on('page:load', ready)
