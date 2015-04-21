module InfoHelper

  def about_icon str, color = true
    image_tag "icons/#{color ? 'color' : 'no-color'}/128px/#{str}.png"
  end
end
