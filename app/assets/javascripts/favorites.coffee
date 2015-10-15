# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Bootstrap Alerts -
# Function Name - showalert()
# Inputs - message,alerttype
# Example - showalert("Invalid Login","alert-error")
# Types of alerts -- "alert-error","alert-success","alert-info"
# Required - You only need to add a alert_placeholder div in your html page wherever you want to display these alerts "<div id="alert_placeholder"></div>"
# Written On - 14-Jun-2013
# Taken from here: http://stackoverflow.com/a/17118264/414642
showAlert = (message, alerttype) ->
  # TODO: need a better CSS to show this
  $('#dynamic-alerts').append('<div id="alertdiv" class="alert ' +  alerttype + '"><a class="close" data-dismiss="alert">×</a><span>'+message+'</span></div>')

  # this will automatically close the alert and remove this if the users doesnt close it in 5 secs
  setTimeout ->
    $("#alertdiv").remove()
  , 5000

$(document).on 'page:change', ->

  # favorite/unfavorite buttons
  changeCount = (e, n) ->
    $('span.favorite-count', e.parent()).each (i, count) ->
      count.innerHTML = parseInt(count.innerHTML) + n

  swapClasses = (e) ->
    $('a.favorite', e.parent()[0]).toggleClass('hidden')
    $('a.unfavorite', e.parent()[0]).toggleClass('hidden')

  $('a.favorite').click ->
    swapClasses($(this))
    changeCount($(this), 1)
    # showAlert('You added this artifact to your favorites', 'alert-success')

  $('a.unfavorite').click ->
    swapClasses($(this))
    changeCount($(this), -1)
    # showAlert('Removed this artifact from your favorites', 'alert-success')