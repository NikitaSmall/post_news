# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->

  $('#new_post, [id^=edit_post_]').validate(
    debug: true
    rules:
      'post[title]':
        required: true
        remote:
          url: 'posts/check_title'
          type: 'uniqueness'
          message: 'Должно быть уникальным'
      'post[photo]':
        required: true
      'post[content]':
        required: true
  )
