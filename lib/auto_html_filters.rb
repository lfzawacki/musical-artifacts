AutoHtml.add_filter(:audio) do |text|
  text.gsub(/https?:\/\/.+\.(mp3|ogg|flac|wav)(\?\S+)?/i) do |match|
    %|<audio src="#{match}" preload="none"></audio>\n <div class="track-details">#{match.split('/')[-1]}</div>|
  end
end

AutoHtml.add_filter(:js_email) do |text|
  text.gsub(/([A-Za-z0-9_.+]+@)([^\n\s<>]+)[\s]*/) do |match|
  text = <<JS
<div id="secure-mail">
</div>

<script TYPE="text/javascript">
  $(document).on('page:change', function() {
    <!--
    // protected email script by Joe Maller
    // JavaScripts available at http://www.joemaller.com
    // this script is free to use and distribute
    // but please credit me and/or link to my site

    emailE=("#{$1}" + "#{$2}")
    $('#secure-mail').html('<a href="mailto:' + emailE + '">' + emailE + '</a>')
     //-->
  });
</script>

<noscript>
  <em>Email address protected by JavaScript.
  Please enable JavaScript to read it.</em>
</noscript>

JS
  end
end