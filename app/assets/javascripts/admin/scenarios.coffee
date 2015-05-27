ready = ->

  window.flowchart = null;

  window.jsPlumbConfig =
    endpoint: "Blank"
    overlays: [ [ "Arrow",
      width: 12
      length: 12
     ] ]
    paintStyle:
      strokeStyle: "#000000"
      fillStyle: "transparent"
      radius: 7
      lineWidth: 3

    isSource: true
    connector: [ "Flowchart",
      stub: [ 40, 40 ]
      gap: 0
      cornerRadius: 5
      alwaysRespectStubs: true
      midpoint: 1
     ]

  sleep = (ms) ->
    start = new Date().getTime()
    continue while new Date().getTime() - start < ms

  class Scenario
    container = $("#scenario-builder")
    id = 0;
    initialized = false;

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

    draw: (obj) ->

      obj = (if typeof obj isnt "undefined" then obj else @obj)

      if initialized
        flowchart.detachEveryConnection();
        flowchart.reset();
        container.empty();
        window.flowchart = null;
      window.flowchart = jsPlumb.getInstance();

      # Briefing
      $("<ul><li id=\"node-#{obj.briefing.id}\"><fc-decision data-id=\"#{obj.briefing.id}\"><fc-add></fc-add><fc-remove></fc-remove>#{obj.briefing.content}</fc-decision><ul></ul></li></ul>").appendTo(container);

      flowchart.setSuspendDrawing(true);

      # Children
      this.children(obj.briefing)

      flowchart.setSuspendDrawing(false);
      flowchart.repaintEverything()

      initialized = true

    children: (obj) ->
      for child of obj.children
        el = $("#node-#{obj.id}").children("ul")
        newEl = $("<li id=\"node-#{obj.children[child].id}\"><fc-decision data-id=\"#{obj.children[child].id}\"><fc-add></fc-add><fc-remove></fc-remove>#{obj.children[child].content}</fc-decision><ul></ul></li>").appendTo(el);

        scenario.connect(obj.id, obj.children[child].id)

        if obj.children[child].children
          this.children(obj.children[child])

    connect: (source, target) ->
      sourceEl = $("#node-#{source}").children('fc-decision')
      targetEl = $("#node-#{target}").children('fc-decision')

      flowchart.connect
        source: sourceEl
        target: targetEl
        anchor: [ "Top", "Bottom" ],
        jsPlumbConfig

  $(document.body).on "click", "fc-add", ->
    id = parseInt($(this).parent().attr("data-id"))
    scenario.node("question", id, "dit is een test")
    scenario.draw()

  window.scenario = new Scenario(window.obj = {}, "Dit is de briefing");

  scenario.node("question", 0, "question 1")
  scenario.node("question", 0, "question 2")
  scenario.node("question", 0, "question 3")
  scenario.node("question", 3, "question 2")
  scenario.node("question", 3, "question 2")
  scenario.draw()
  flowchart.repaintEverything()

  #e1 = jsPlumb.addEndpoint("node-0",isSource: true)
  #e2 = jsPlumb.addEndpoint("node-1",isTarget: true)
  #console.log(e1)

  #scenario.connect("node-0","node-1")

    # if obj.children[child].children
    #   this.children(obj.children[child])

  #scenario.node("question", null, "test");

  $(window).resize ->
    flowchart.repaintEverything()

jsPlumb.ready(ready)
# $(document).on('page:load', ready)

# jsPlumb.bind "ready", ->
#   jsPlumb.connect({source:"node-0", target:"node-1"})
