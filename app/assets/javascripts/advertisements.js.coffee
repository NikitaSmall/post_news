# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

on_ready = ->

  $('[id^=new_advertisement]').validate(
    #debug: true
    ignore: []
    rules:
      'advertisement[title]':
        required: true
      'advertisement[link]':
        required: true
      'advertisement[photo]':
        required: true
      'advertisement[content]':
        required: (textarea) ->
          CKEDITOR.instances[textarea.id].updateElement() # update textarea
          editorcontent = textarea.value.replace(/<[^>]*>/gi, '') # strip tags
          return editorcontent.length == 0
    errorPlacement: (error, element) ->
      if element.attr('id') == 'content'
        error.insertBefore 'textarea#content'
      else
        error.insertBefore element
  )

$(document).ready(on_ready)
$(document).on('page:load', on_ready)