ready = ->
  if $("#scenario-builder").length
    jsPlumb.ready(scenariobuilder)

scenariobuilder = ->

  linkParentId = null
  linkQueue = []
  activeid = null
  window.roles = []

  ### Configuration ###
  wrapper = $("#scenario-builder-wrapper")
  container = $("#scenario-builder")
  window.flowchart = null;
  initialized = false;
  window.jsPlumbConfig =
    endpoint: "Blank"
    overlays: [ [ "Arrow",
      width: 12
      length: 12
      foldback: 0.5
     ] ]
    paintStyle:
      strokeStyle: "#333a3c"
      fillStyle: "transparent"
      radius: 7
      lineWidth: 3

    isSource: true
    connector: [ "Flowchart",
      stub: [ 40, 40 ]
      gap: 0
      cornerRadius: 5
      alwaysRespectStubs: true
      midpoint: 0.5
     ]

  class Scenario
    idCount = 0
    title = null
    briefing = null
    timeBudget = null
    moneyBudget = null
    window.scenarioId = null

    constructor: (@obj, @briefing) ->
      this.addNode("briefing", null, @briefing)

    debug: ->
      console.log idCount
      console.log title
      console.log briefing
      console.log timeBudget
      console.log moneyBudget
      console.log window.scenarioId
      console.log roles


    addNode: (@type, @parent, @content) ->

      switch @type
        when "briefing"
          if !@obj.briefing # Check if briefing exists
            @obj['briefing'] = {
              id: idCount++,
              type:"briefing",
              parent:null,
              content:@content,
              children:[]
            };
          else
            obj.briefing.content = @content;
        when "choice"
          if @parent is 0
            parent = @obj.briefing
          else
            parent = this.getObject(@parent, @obj.briefing)
            parent = parent[0]

          child = {
            id: idCount++,
            type:"choice",
            parent:@parent,
            content:@content,
            children:[],
            link_to:null
          };

          parent.children.push child

    removeNode: (val, obj) ->
      item = this.getObject(val, obj, true)
      this.draw()

    getObject: (val, obj, remove) ->
      remove = (if typeof remove isnt "undefined" then remove else false)
      obj = (if typeof obj isnt "undefined" then obj else @obj)
      object = []

      #for child of obj.children # for each item in children
      i = 0
      while i < obj.children.length
        if typeof obj.children[i] is "undefined"
          i++
          continue
        if obj.children[i].id is val # check if item.id matches val
          if remove
            delete obj.children[i]
            obj.children.length--
            object.push true
            break

          object.push obj.children[i] # if it does, push it into the object array
          break # and stop the for loop

        if obj.children[i].children
          object = this.getObject(val, obj.children[i], remove) # then loop over these as well
          if object.length > 0 # and if anything returns
            break # stop the for loop

        i++

      object # and finally return the object

    save: ->
      # Get values from DOM if not stored in JS yet (new scenario vs load)
      title = $("#form-scenario-title").val()  if title is null
      briefing = $("#form-scenario-briefing").val()  if briefing is null
      timeBudget = $("#form-scenario-time-budget").val()  if timeBudget is null
      moneyBudget = $("#form-scenario-money-budget").val()  if moneyBudget is null

      if roles.length == 0
        $(".role").each ->
          role =
            name: $(this).find("#form-scenario-role-name").val()
            role: $(this).find("#form-scenario-role-role").val()

            description: $(this).find("#form-scenario-role-description").val()
          roles.push role

      # Create a temp. scenario object
      scenario =
        title: title
        idCount: idCount
        briefing: briefing
        timeBudget: timeBudget
        moneyBudget: moneyBudget
        roles: roles

      scenario['scenario'] = @obj
      JSON.stringify(scenario)

    load: (obj, id) ->
      json = JSON.parse( obj.responseText )
      scenario = JSON.parse(json.data)
      window.scenarioId = id
      @obj = scenario['scenario']
      window.obj = @obj

      title = scenario['title']
      idCount = scenario['idCount']
      briefing = scenario['briefing']
      timeBudget = scenario['timeBudger']
      moneyBudget = scenario['moneyBudget']
      window.roles = scenario['roles']

      console.log roles

      this.draw()

    ajax_save: (obj, id) ->
      id = (if typeof id isnt "undefined" then id else window.scenarioId)

      request = $.ajax
        type: "POST",
        dataType: "json"
        url: "/admin/scenarios/ajax_save"
        data: "data=" + obj + "&id=" + id

      request.done (data) ->
        window.scenarioId = data.id

      request.fail (jqXHR, textStatus) ->
        alert "Request failed: " + textStatus

    ajax_load: (id) ->
      request = $.ajax
        dataType: "json"
        url: "/admin/scenarios/ajax_load"
        data: "id=" + id

      request.done (data) ->
        return data

      request.fail (jqXHR, textStatus) ->
        alert "Request failed: " + textStatus

    getRoles: (obj) ->
      if window.roles.length == 0
        $(".role").each ->
          role =
            name: $(this).find("#form-scenario-role-name").val()
            role: $(this).find("#form-scenario-role-role").val()
            description: $(this).find("#form-scenario-role-description").val()
          window.roles.push role

      return window.roles

    draw: (obj) ->

      obj = (if typeof obj isnt "undefined" then obj else @obj)

      if initialized
        minHeight = container.height()
        container.css('min-height', minHeight);
        flowchart.detachEveryConnection();
        flowchart.reset();
        container.empty();
        window.flowchart = null;
      window.flowchart = jsPlumb.getInstance();

      # Briefing
      $("<ul><li id=\"node-#{obj.briefing.id}\"><fc-node class=\"briefing\" data-id=\"#{obj.briefing.id}\"><fc-edit><i class=\"fa fa-pencil fa-2x\"></i></fc-edit><fc-add><i class=\"fa fa-plus-circle fa-2x\"></i></fc-add>Briefing</fc-node><ul></ul></li></ul>").appendTo(container);

      flowchart.setSuspendDrawing(true);

      # Children
      this.children(obj.briefing)

      for object in linkQueue
        this.connect(object['parent'], object['link_to'], ["Left","Right"])
      linkQueue = []

      flowchart.setSuspendDrawing(false);
      flowchart.repaintEverything()

      initialized = true

      if initialized
        ulHeight = container.children("ul").children("li").height()

        # If container is smaller then the window, set minimum height to window height
        # Minus navbar height so that the container will hit the bottom of the window
        if ulHeight < (window.innerHeight - $('.navbar').height()) && container.height() < (window.innerHeight - $('.navbar').height())
          container.css("min-height", window.innerHeight - $('.navbar').height())
          minHeight = container.height()

        # Scroll container height up if it's larger then the content
        if ulHeight < minHeight
          if ulHeight < (window.innerHeight - $('.navbar').height())
            container.animate({ 'min-height': window.innerHeight - $('.navbar').height() }, "slow", "easeInOutCubic");
          else
            container.animate({ 'min-height': ulHeight }, "slow", "easeInOutCubic");

        # if minHeight < (window.innerHeight - $('.navbar').height())
        #   console.log(window.innerHeight - $('.navbar').height())

        #   container.height(window.innerHeight - $('.navbar').height())


    children: (obj) ->

      for child of obj.children
        el = $("#node-#{obj.id}").children("ul")

        if obj.children[child].link_to == null
          link = "<fc-link><i class=\"fa fa-link fa-2x\"></i></fc-link>"
          add = "<fc-add><i class=\"fa fa-plus-circle fa-2x\"></i></fc-add>"
        else
          link = "<fc-link-remove><i class=\"fa fa-chain-broken fa-2x\"></i></fc-link-remove>"
          add = ""
          linkQueue.push {parent:obj.children[child].id,link_to:obj.children[child].link_to}

        newEl = $("<li id=\"node-#{obj.children[child].id}\"><fc-node class=\"#{obj.children[child].type}\" data-id=\"#{obj.children[child].id}\"><fc-edit><i class=\"fa fa-pencil fa-2x\"></i></fc-edit>#{link}<fc-remove><i class=\"fa fa-trash fa-2x\"></i></fc-remove>#{add}#{obj.children[child].content}</fc-node><ul></ul></li>").appendTo(el);

        scenario.connect(obj.id, obj.children[child].id)

        if obj.children[child].children
          this.children(obj.children[child])

    connect: (source, target, anchor) ->
      anchor = (if typeof anchor isnt "undefined" then anchor else ["Top","Bottom"])

      sourceEl = $("#node-#{source}").children('fc-node')
      targetEl = $("#node-#{target}").children('fc-node')

      flowchart.connect
        source: sourceEl
        target: targetEl
        anchor: anchor,
        jsPlumbConfig

  $(document.body).on "click", "fc-edit", ->
    $(".builder-sidebar").empty()
    id = parseInt($(this).parent().attr("data-id"))
    activeid = id
    if id == 0
      node = obj.briefing
    else
      node = scenario.getObject(id, obj.briefing)[0]
    host = document.querySelector('.builder-sidebar')
    template = document.querySelector('#form-edit-choice')
    clone = document.importNode(template.content, true)
    host.appendChild(clone)

    $("#select-roles").empty()

    $.each window.roles, (index, value) ->
      role = value
      $("#select-roles").append('<option>'+ role.role + ' (' + role.name + ')</option>')

    $("#standard-response").val(node.content)

    # scenario.addNode("question", id, "dit is een test")
    # scenario.draw()

  $(document.body).on "click", "fc-add", ->
    $(".builder-sidebar").empty()
    id = parseInt($(this).parent().attr("data-id"))
    activeid = id
    host = document.querySelector('.builder-sidebar')
    template = document.querySelector('#form-add-choice')
    clone = document.importNode(template.content, true)
    host.appendChild(clone)

    $("#select-roles").empty()
    $.each window.roles, (index, value) ->
      role = value
      $("#select-roles").append('<option>'+ role.role + ' (' + role.name + ')</option>')

  $(document.body).on "click", ".add-choice", (e) ->
    e.preventDefault()
    scenario.addNode("choice", activeid, $("#standard-response").val())
    scenario.draw()
    $(".builder-sidebar").empty()

  $(document.body).on "click", ".edit-choice", (e) ->
    e.preventDefault()
    if activeid == 0
      node = obj.briefing
    else
      node = scenario.getObject(activeid, obj.briefing)[0]
    node.content = $("#standard-response").val()
    scenario.draw()
    $(".builder-sidebar").empty()

  $(document.body).on "click", "fc-remove", ->
    id = parseInt($(this).parent().attr("data-id"))
    scenario.removeNode(id, window.obj.briefing)

  $(document.body).on "click", "#form-scenario-save", ->
    json = scenario.save(window.obj)
    scenario.ajax_save(json, window.scenarioId)


  $(document.body).on "click", "fc-node", (e) ->
    return unless e.target is this #Negeer clicks op children

    id = parseInt($(this).attr("data-id"))

    if linkParentId != null && id != linkParentId
      child = scenario.getObject(id, obj.briefing)[0]
      parent = scenario.getObject(linkParentId, obj.briefing)[0]
      if child.link_to == parent.id
        linkParentId = null
        alert "Mag niet heen en weer linken"
        return
      parent.link_to = id
      linkParentId = null

      scenario.draw()
      return

    # if id == 0
    #   node = obj.briefing
    # else
    #   node = scenario.getObject(id, obj.briefing)[0]
    # node.content = "test"
    # scenario.draw()

  # container.click (e) ->
  #   return unless e.target is this

  $(document.body).on "click", "fc-link-remove", ->
    id = parseInt($(this).parent().attr("data-id"))
    node = scenario.getObject(id, obj.briefing)[0]
    node.link_to = null
    scenario.draw()


  $(document.body).on "click", "fc-link", ->
    linkParentId = parseInt($(this).parent().attr("data-id"))
    alert "nu mag je op een node klikken"

  $("#form-scenario-new").click ->
    briefing = $("#form-scenario-briefing").val()
    window.scenario = new Scenario(window.obj = {}, briefing)
    scenario.getRoles(window.obj)
    scenario.draw()
    $("#scenario-briefing").hide()
    $("#scenario-builder-wrapper").show()
    $("#wrapper").scrollTop(0).toggleClass "toggled" if !$("#wrapper").hasClass("toggled")

  # if $("#scenario-builder").length
  #   window.scenario = new Scenario(window.obj = {}, "Dit is de briefing");

  #   scenario.draw()
  #   $("#scenario-briefing").hide()
  #   $("#scenario-builder-wrapper").show()
  #   flowchart.repaintEverything()

  #   $("#wrapper").toggleClass "toggled" if !$("#wrapper").hasClass("toggled")

    # $("#scenario-builder").panzoom();

  $(window).on "resize", ->
    flowchart.repaintEverything()

  # This is code to add more roles in the scenario setup
  $(".add-role-button").click ->
    addRole()

  roleCount = 0;
  addRole = ->
    host = document.querySelector('.insert-roles')
    template = document.querySelector('#role-template')
    clone = document.importNode(template.content, true)
    host.appendChild(clone)
    roleCount++
    $(".roles").children(".role").last().children("h4").text("Rol " + roleCount)
    $(".roles").children(".role").last().attr("data-roleID",roleCount);

  addRole()

$(document).ready(ready)
$(document).on('page:load', ready)
