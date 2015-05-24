# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

on_ready = ->
  id = $('#social_share').data('id')
  if(typeof id != 'undefined')
    $.ajax
      url: '/visit_post/' + id
      method: 'post'
      success:
        console.log('post ' + id + ' was viewed')
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")

  # console.log(id)
  $('.social-share-button a').on 'click', ->
    $.ajax
      url: '/share/' + id
      method: 'post'
      success:
        console.log('post ' + id + ' was shared!')
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")

  advertisement_id = $("a[target='_blank']").data('id')
  $("a[target='_blank']").on 'click', ->
    $.ajax
      url: '/advertise/' + advertisement_id
      method: 'post'
      success:
        console.log('advertisement ' + advertisement_id + ' was shared!')
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")

$(document).ready(on_ready)
$(document).on('page:load', on_ready)
