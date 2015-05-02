# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->

  $('#new_post, form.edit_post').validate(
    #debug: true
    rules:
      'post[title]':
        required: true
        remote:
          url: '/posts_check_title.json'
          type: 'post'
      'post[photo]':
        required: true
     'post[content]':
        required: true
    message:
      'post[title]':
        remote: 'Название должно быть уникальным'
  )
