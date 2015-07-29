# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'page:change', ->
  $ ->
    $('.enable-field').click (e) ->
      field = $(this).data('field')
      $("##{field}").prop 'disabled', (i, v) ->
        !v

      e.preventDefault()