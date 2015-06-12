# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

on_ready =->
  $('[id^=ads_num_form]').validate(
    ignore: []
    rules:
      'value':
        required: true
        min: 0
    errorPlacement: (error, element) ->
      error.appendTo( element.parent("div") )
  )

  $('[id^=tag_count_form]').validate(
    ignore: []
    rules:
      'value':
        required: true
        min: 0
    errorPlacement: (error, element) ->
      error.appendTo( element.parent("div") )
  )

$(document).on('page:load', on_ready)
$(document).ready(on_ready)