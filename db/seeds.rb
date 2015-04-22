# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
License.create short_name: 'public', name: 'Public Domain'
License.create short_name: 'by', name: 'Creative Commons Attribution 3.0 Unported License.'
License.create short_name: 'by-sa', name: 'Creative Commons Attribution-ShareAlike 3.0 Unported License.'
License.create short_name: 'by-nd', name: 'Creative Commons Attribution-NoDerivs 3.0 Unported License.'
License.create short_name: 'by-nc', name: 'Creative Commons Attribution-NonCommercial 3.0 Unported License.'
License.create short_name: 'by-nc-sa', name: 'Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.'
License.create short_name: 'by-nc-nd', name: 'Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License.'
License.create short_name: 'copyright', name: 'Copyright belongs to the author.'

App.create(
  name: "Guitarix",
  description: "Guitarix is a virtual guitar amplifier for Linux running on Jack Audio Connection Kit. It is free as in speech and free as in beer. The available sourcecode allows to build it on other UNIX-like systems, too, namely for BSD and for MacOSX.",
  url: "http://guitarix.sourceforge.net",
  software_list: ['guitarix'],
  file_format_list: ['gx']
)

App.create(
  name: "ZynAddSubFx / Yoshimi",
  url: 'http://zynaddsubfx.sourceforge.net/',
  software_list: ['zynaddsubfx', 'yoshimi'],
  file_format_list: ['xmz', 'xiz', 'xpf']
)

App.create(
  name: 'Linuxsampler',
  url: 'https://www.linuxsampler.org',
  software_list: ['linuxsampler', 'qsampler', 'fantasia'],
  file_format_list: ['gig', 'sf2', 'sfz']
)

Artifact.create(
  name: 'Heavy Rhythm Guitar Distortion',
  mirrors: ['http://lfzawacki.com/distortion.gx', 'http://lfzawacki2.com/distortion.gx'],
  author: 'Lucas Fialho Zawacki',
  description: 'Heavy but not too dirty distortion for rhythm playing, good for layering. Uses the mesa boogie cabinet and is very bassy.',
  software_list: ['guitarix'],
  tag_list: ['preset', 'guitar','distortion', 'rock', 'heavy metal'],
  license_id: 2
)

Artifact.create(
  name: 'Clean Guitar with Reverb',
  mirrors: ['http://lfzawacki.com/clean.gx', 'http://lfzawacki2.com/clean.gx'],
  author: 'Lucas Fialho Zawacki',
  description: 'Clean and trebley guitar sound drenched with lots of reverb',
  software_list: ['guitarix'],
  tag_list: ['preset', 'guitar','clean', 'reverb', 'rock'],
  license_id: 2
)

Artifact.create(
  name: 'Salamander Grand Piano v3',
  mirrors: ['http://archive.org', 'http://salamander-piano.net'],
  author: 'Alexander Holm',
  description: '16 Velocity layers Sampled in minor thirds from the lowest A. Hammer noise releases chromatically sampled in onle one layer. String resonance releases in minor thirds in three layers. Two AKG c414 disposed in an AB position ~12cm above the strings',
  software_list: ['linuxsampler'],
  tag_list: ['piano', 'sampled', 'sfz'],
  license_id: 2
)