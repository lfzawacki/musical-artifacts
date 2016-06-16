#
# Code for setting off notifications after some key moments
#

$(document).on 'page:change', ->

  PNotify.prototype.options.styling = "bootstrap3"

  $('.timed-notification').each ->

    id = $(this).attr('id')
    time = $(this).data('time')
    title = $(this).data('title')
    text = $(this).data('text')
    custom_class = $(this).data('custom-class')

    setTimeout ->
      new PNotify
        title: title
        text: text
        addclass: 'timed-notification-box'
        icon: false
        buttons:
          sticker: false

        # Dismiss survey for 24 hours
        before_close: ->
          $.ajax
            type: "POST",
            url: "/notifications/#{id}/dismiss",

    , time*1000

  $('.alert-notification').each ->

    convert_type = (alert_type) ->
      { notice: 'success', alert: 'error'}[alert_type] or alert_type

    type = $(this).data('alert-type')
    text = $(this).data('text')

    setTimeout ->
      new PNotify
        text: text
        type: convert_type(type)
        buttons:
          sticker: false
      , 2000

  # $('.click-notification').on 'click', ->
  #   new PNotify
  #     title: 'Click'
  #     text: 'Notify yah'
