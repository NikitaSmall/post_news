# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

on_ready = ->

  name = $('#content').attr('name')

  $('[id^=new_post]').validate(
    #debug: true
    ignore: []
    rules:
      #content:
      #  required: ->
      #    CKEDITOR.instances.content.updateElement()
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

    message:
      'post[title]':
        remote: 'Название должно быть уникальным'
    errorPlacement: (error, element) ->
      if element.attr('id') == 'content'
        error.insertBefore 'textarea#content'
      else
        error.insertBefore element
  )

$(document).ready(on_ready)
$(document).on('page:load', on_ready)

  #$('[id^="edit_post_"]').validate(
  #  #debug: true
  #  rules:
  #    'post[title]':
  #      required: true
  #      remote:
  #        url: '/posts_check_title.json'
  #        type: 'post'
  #    'post[photo]':
  #      required: true
  #  'post[content]':
  #    required: true
  #  message:
  #    'post[title]':
  #      remote: 'Название должно быть уникальным'
  #)
