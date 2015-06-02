ready = ->
  $("#menu-toggle").click (e) ->
    e.preventDefault()
    $("#wrapper").toggleClass "toggled"

  $("button").click (e) ->
    e.preventDefault()

$(document).ready(ready)
$(document).on('page:load', ready)
