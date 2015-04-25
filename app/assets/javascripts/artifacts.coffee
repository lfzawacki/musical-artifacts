# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

initialize_select =  (field_id, url) ->
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
        results: data

  $(field_id).ready ->
    values = []
    for value in $(field_id).val()?.split(',')
      values.push {id: value, text: value}

    $(field_id).select2 'data', values

updateArtifacts = (value, target) ->
  target.load "/?q=#{value}"

$(document).on 'page:change', ->

  # ------ index
  if $('#artifact_search')[0]
    timeout = null
    $('#artifact_search').on 'keyup', (e) ->
      value = $(this).val()
      history.replaceState({q: value}, "/?q=#{value}", "/?q=#{value}")

      clearTimeout(timeout)
      timeout = setTimeout(updateArtifacts, '300', value, $("#artifact-list"))

  $("[name='license']").bootstrapSwitch()
  $("[name='apps']").bootstrapSwitch()
  $("[name='tags']").bootstrapSwitch()
  $("[name='hash']").bootstrapSwitch()

  # ------ _form
  initialize_select '#artifact_tag_list', '/searches/tags'
  initialize_select '#artifact_software_list', '/searches/software'

  if $('#artifact_license_id')[0]
    $('#artifact_license_id').select2()

  if $('#artifact_mirrors')[0]
    $('#artifact_mirrors')?.select2
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

