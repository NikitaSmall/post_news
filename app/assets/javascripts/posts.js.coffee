# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

on_ready = ->

  name = $('#content').attr('name')

  $('[id^=new_post]').validate(
    #debug: true
    ignore: []
    rules:
      'post[title]':
        required: true
        remote:
          url: '/posts_check_title.json'
          type: 'post'
      'post[photo]':
        required: true
      'post[content]':
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

  if $('#post_main').is(':checked')
    $('#post_featured').prop 'disabled', false
  else
    $('#post_featured').removeAttr 'checked'
    $('#post_featured').prop 'disabled', true

  $('#post_main').click ->
    if $('#post_main').is(':checked')
      $('#post_featured').prop 'disabled', false
    else
      $('#post_featured').removeAttr 'checked'
      $('#post_featured').prop 'disabled', true

$(document).ready(on_ready)
$(document).on('page:load', on_ready)