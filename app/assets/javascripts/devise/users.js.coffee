# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

on_ready = ->
  $('#register').validate(
    #debug: true
    ignore: []
    rules:
      'user[username]':
        required: true
        minlength: 3
        maxlength: 50
        lettersonly: true
        remote:
          url: '/user_check_username'
          type: 'post'
      'user[email]':
        required: true
        email: true
        remote:
          url: '/user_check_email.json'
          type: 'post'
      'user[password]':
        required: true
        minlength: 8
      'user[password_confirmation]':
        required: true
        equalTo: '#user_password'
    errorPlacement: (error, element) ->
        error.insertBefore element
  )

$(document).ready(on_ready)
$(document).on('page:load', on_ready)