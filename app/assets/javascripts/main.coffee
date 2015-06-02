ready = ->
  $("#menu-toggle").click (e) ->
    e.preventDefault()
    $("#wrapper").toggleClass "toggled"

  $("button").click (e) ->
    e.preventDefault()

  $.fn.datepicker.defaults.format = "dd/mm/yyyy";
  $(".datepicker").datepicker("setDate", new Date())

$(document).ready(ready)
$(document).on('page:load', ready)
