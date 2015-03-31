# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'page:change', ->

  if $('#artifact_license_id')
    $('#artifact_license_id').select2()

  if $('#artifact_tag_list')
    $('#artifact_tag_list').select2
      minimumInputLength: 3
      tags: []
      width: 'resolve'
      tokenSeparators: [',', ';']

  if $('#artifact_software_list')
    $('#artifact_software_list').select2
      minimumInputLength: 3
      tags: []
      width: 'resolve'
      tokenSeparators: [',', ';']
