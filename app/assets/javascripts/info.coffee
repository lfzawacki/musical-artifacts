# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# WINNING
hideElements = ->
  if $('.juvia-comments')[0]
    $('.juvia-comments + h3').remove()
    $('.juvia-comments').remove()
    $('.juvia-comment-count-header').remove()
  else
    setTimeout(hideElements, 50)

$(document).on 'page:change', ->

  $('#comments').show()

  if $('#comments.hide-headers')[0]
    setTimeout(hideElements, 50)