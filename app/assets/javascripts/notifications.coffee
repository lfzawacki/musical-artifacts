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
        opacity: .8
        hide: false
        buttons:
          sticker: false

        # Dismiss survey for 24 hours
        before_close: ->
          $.ajax
            type: "POST",
            url: "/notifications/#{id}/dismiss",

    , time*1000

  # $('.click-notification').on 'click', ->
  #   new PNotify
  #     title: 'Click'
  #     text: 'Notify yah'
