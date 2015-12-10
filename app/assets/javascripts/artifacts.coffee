# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

artifact_search_fields = ['apps', 'tags', 'license', 'hash', 'formats']

initialize_select = (field_id, url) ->
  return if not $(field_id)[0]

  $(field_id).select2
    minimumInputLength: 1
    width: 'resolve'
    multiple: true
    tags: true
    tokenSeparators: [',', ';']

    createSearchChoice: (term, data) ->
      { id: term, text: term }

    formatSelection: (object, container) ->
      object.text

    ajax:
      url: url + '.json'
      dataType: 'json'
      data: (term, page) ->
        q: term
      results: (data, page) ->
        results: data.map (term) -> {id: term, text: term}

  $(field_id).ready ->
    values = []

    for value in $(field_id).val().split(',')
      values.push {id: value, text: value} if value != ''

    $(field_id).select2 'data', values

select_for_http_links = (id) ->
  if $(id)[0]
    $(id)?.select2
      minimumResultsForSearch: Infinity
      tags: []
      width: 'resolve'
      tokenSeparators: [',', ';']

      formatSelection: (object, container) ->
        # Assume a url has been entered and stick a http:// in front if it's not there
        if not object.text.match(/^http[s]?\:\/\//)
          'http://' + object.text
        else
          object.text

initialize_wayback_links = ->
  wayback_url = 'https://web.archive.org/web/*/'
  $('#show-wayback-links').on 'click', (e) ->
    shown = $(this).data('shown')

    # toggle shown status
    $(this).data 'shown', !shown

    $('.external-link').each ->
      if !shown
        $(this).data('old-href', $(this).attr('href'))
        $(this).attr('href', wayback_url + $(this).attr('href'))
        $(this).addClass('wayback')
        $(this).removeClass('normal')
      else
        $(this).attr('href', $(this).data('old-href'))
        $(this).data('old-href', '')
        $(this).addClass('normal')
        $(this).removeClass('wayback')

    $('#show-wayback-links .on-shown').toggle()
    $('#show-wayback-links .on-hidden').toggle()

    e.preventDefault()

# Load juvia comments
# TODO: Document this hacky mess PLZ
initialize_comments = ->
  hide_time = 200
  slow_hide_time = 1000
  animate_time = 2000

  $('#show-comments').click (e) ->

    # Hide button and show loading
    $('#show-comments').fadeOut hide_time, ->
      $('#load-comments').fadeIn()

    # Load juvia comments
    $('#comments').load '/comments_script.html', ->

      # Wait a while until comments show
      showComments = ->
        $('#comments').show ->
          # Hide loading and show 'Hide Comments'
          $('#load-comments').fadeOut(hide_time)
          $('#hide-comments').fadeIn(hide_time)

          # Move screen to the top of the comment section
          $('html, body').animate
            scrollTop: $("#comments").offset().top - 120
          , animate_time

          # Reset comments when clicking the '#hide-comments' button
          $('#hide-comments a').click (e) ->
            $('#comments').hide slow_hide_time, ->
              $(this).empty()

              $('#hide-comments').hide()
              $('#show-comments').show()

            e.preventDefault()

      setTimeout(showComments, animate_time)

    e.preventDefault()

initialize_audio_player = ->
  audiojs.events.ready ->
    as = audiojs.createAll
      imageLocation: $('#audiojs-data').attr('imageLocation')
      swfLocation: $('#audiojs-data').attr('swfLocation')

initialize_file_tree = ->
  # Only called if #file-tree div is present
  # TODO: find a way to disable file select as it doesnt make sense
  $('#file-tree').jstree()

initialize_mirror_links = ->
  $('.mirror-link').on 'click', (e) ->
  # Get the first mirror (which is our own)
  url = $('ul#mirrors a:first').attr('href')
  clicked_url = $('a:first', $(this)).attr('href')

  reg = new RegExp(location.host)

  # Tests if the first mirror is present (we have the file hosted in musical artifacts)
  if reg.test(url) and clicked_url != url
    # Do a head request to increase download count
    http = new XMLHttpRequest()
    http.open('HEAD', url)
    http.send()

updateFormParameters = ->
  params = parseQueryString($('#artifact_search').val())

  for field in artifact_search_fields.concat(['q'])
    if params[field]?
      $("[name='#{field}']").attr('value', params[field])
    else
      $("[name='#{field}']")[0].disabled = true

  $("[name='search']")[0].disabled = true

  for field in artifact_search_fields
    $("[name=checkbox_#{field}]")[0].disabled = true

updateSearchField = (field, state) ->
  search_field = $('#artifact_search')[0]

  # adding a field
  if state
    search_field.value = search_field.value
    if search_field.value.length > 0 && search_field.value.slice(-1) != ' '
      search_field.value = search_field.value + ' '

    search_field.value = search_field.value + field + ': '

  else # removing
    possible_fields = ("#{f}:" for f in artifact_search_fields)

    regexp = RegExp(".*(#{field}:.*)(#{possible_fields.join('|')})?.*")
    found = search_field.value.match(regexp)[1]
    search_field.value = search_field.value.replace(found, '')

    # check for an empty field with whitespace
    if search_field.value.match(RegExp("^\s*$"))
      search_field.value = ''

paramsToString = (params) ->
  str = ''
  first = true

  if Object.keys(params).length > 0
    str += '?'
    for param, value of params
      if param != 'search'
        str += "#{if first then '' else '&'}#{param}=#{value}"
        first = false

  str

parseQueryString = (str) ->
  params = {}

  # gets the value of one parameter and deletes it
  parseItem = (param) ->
    possible_fields = ("#{f}:" for f in artifact_search_fields)

    regexp1 = RegExp("(#{param}:(.*))(#{possible_fields.join('|')})")
    regexp2 = RegExp("(#{param}:(.*))(#{possible_fields.join('|')})?")
    match = str.match(regexp1) or str.match(regexp2)

    if match
      text = $.trim(match[2])
      params[param] = encodeURIComponent(text) if text.length > 0 # store the param if it's not empty
      str = str.replace(match[1], '') # remove the param from the url

  parseItem(filter) for filter in artifact_search_fields

  str = $.trim(str) # the rest is the query
  params['q'] = str if str.length > 0
  params

$(document).on 'page:change', ->

  # ------ index
  if $('#artifact_search')[0]
    input = $('#artifact_search')

    # Send form
    $('form#artifact_search_form').submit ->
      updateFormParameters()

  # ------ search filters
  for filter in artifact_search_fields
    $("input.filter[name='checkbox_#{filter}']").attr('checked', String(window.location).match(filter + '='))

  $('input.filter').change (event) ->
    field = $(this).attr('name').match(RegExp("checkbox_(.*)"))[1]

    updateSearchField(field, $(this).is(':checked'))
    setTimeout ->
      $('#artifact_search').focus()
    , 300

  # ------ _form
  initialize_select '#artifact_tag_list', '/searches/tags'
  initialize_select '#artifact_software_list', '/searches/apps'
  initialize_select '#artifact_file_format_list', '/searches/file_formats'

  if $('#artifact_license_id')[0]
    $('#artifact_license_id').select2
      width: 'element'

  select_for_http_links('#artifact_mirrors')
  select_for_http_links('#artifact_more_info_urls')

  # ------ show
  initialize_wayback_links()
  initialize_comments()
  initialize_audio_player()
  initialize_file_tree()
  initialize_mirror_links()