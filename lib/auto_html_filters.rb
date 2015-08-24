AutoHtml.add_filter(:audio) do |text|
  text.gsub(/https?:\/\/.+\.(mp3|ogg|flac|wav)(\?\S+)?/i) do |match|
    %|<audio src="#{match}" preload="true"></audio>\n <div class="track-details">#{match.split('/')[-1]}</div>|
  end
end

AutoHtml.add_filter(:js_email) do |text|
  text.gsub(/([A-Za-z0-9_.+]+@)([^\n\s<>]+)[\s]*/) do |match|
  text = <<JS
<SCRIPT TYPE="text/javascript">
<!--
// protected email script by Joe Maller
// JavaScripts available at http://www.joemaller.com
// this script is free to use and distribute
// but please credit me and/or link to my site

emailE=("#{$1}" + "#{$2}")
document.write('<a href="mailto:' + emailE + '">' + emailE + '</a>')
 //-->
</script>

<NOSCRIPT>
    <em>Email address protected by JavaScript.
    Please enable JavaScript to read it.</em>
</NOSCRIPT>
JS
  end
end