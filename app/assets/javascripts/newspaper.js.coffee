# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
on_ready = ->

  $(document).on 'click', '.search-results-wrap .pagination[remote=true] a', ->
    window.history.pushState(null, 'hi', $(this).attr("href"))
    $.rails.handleRemote($(this))
    return false

  id = $('#social_share').data('id')

  # calling a request for visit post check
  if(typeof id != 'undefined')
    $.ajax
      url: '/visit_post/' + id
      method: 'post'
      success:
        console.log('post ' + id + ' was viewed')
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")

  # calling a request for share post check
  $('.social-share-button a').on 'click', ->
    $.ajax
      url: '/share/' + id
      method: 'post'
      success:
        console.log('post ' + id + ' was shared!')
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")

  # calling a request for visit advertisement check
  #$(document).on 'click', "a[target='_blank']", ->
  #  advertisement_id = $(this).data('id')
  #  $.ajax
  #    url: '/advertise/' + advertisement_id
  #    method: 'post'
  #    success:
  #      console.log('advertisement ' + advertisement_id + ' was shared!')
  #    error: (jqXHR, textStatus, errorThrown) ->
  #      console.log("AJAX Error: #{textStatus}")

$(document).ready(on_ready)
$(document).on('page:load', on_ready)


