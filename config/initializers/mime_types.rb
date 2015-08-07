# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf

types = {
  sfz: 'text/plain',
  sf2: 'audio/x-soundfont',
  sfark: 'application/x-extension-sfark',
  gig: 'audio/x-riff',

  midi: 'application/x-midi',
  mid: 'application/x-midi',

  xiz: 'application/x-gzip',
  xmz: 'application/x-gzip',
  xpf: 'text/html',

  torrent: 'application/x-bittorrent',

  h2song: 'application/xml',
  h2drumkit: 'application/gzip',

  # '7z' => 'application/x-7z-compressed',
  rar: 'application/x-rar',
  bz2: 'application/bzip2',
  gz: 'application/x-gzip',
  tar: 'application/x-tar',
  tgz: 'application/x-gzip',

  wav: 'audio/x-wav',
  mp3: 'audio/mpeg',
  ogg: 'audio/ogg',
  flac: 'audio/flac'
}

types.each do |type, str|
  Mime::Type.register str, type.to_sym
end