AutoHtml.add_filter(:audio) do |text|
  text.gsub(/https?:\/\/.+\.(mp3|ogg|flac|wav)(\?\S+)?/i) do |match|
    %|<audio src="#{match}" preload="true"></audio>\n <div class="track-details">#{match.split('/')[-1]}</div>|
  end
end