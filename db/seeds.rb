# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
require './lib/monkey_patches'

License.create short_name: 'public', name: 'Public Domain'

License.create short_name: 'by', license_type: 'cc', name: 'Creative Commons Attribution 4.0 Unported License.'
License.create short_name: 'by-sa', license_type: 'cc', name: 'Creative Commons Attribution-ShareAlike 4.0 Unported License.'
License.create short_name: 'by-nd', license_type: 'cc', name: 'Creative Commons Attribution-NoDerivs 4.0 Unported License.'
License.create short_name: 'by-nc', license_type: 'cc', name: 'Creative Commons Attribution-NonCommercial 4.0 Unported License.'
License.create short_name: 'by-nc-sa', license_type: 'cc', name: 'Creative Commons Attribution-NonCommercial-ShareAlike 4.0 Unported License.'
License.create short_name: 'by-nc-nd', license_type: 'cc', name: 'Creative Commons Attribution-NonCommercial-NoDerivs 4.0 Unported License.'
License.create short_name: 'cc-sample', license_type: 'cc', name: 'Creative Commons Sampling Plus 1.0'

License.create short_name: 'copyright', license_type: 'copyright', name: 'Copyright'

License.create short_name: 'copyleft', license_type: 'gpl', name: 'Copyleft'
License.create short_name: 'gpl', license_type: 'gpl', name: 'GNU General Public License'
License.create short_name: 'gpl-v2', license_type: 'gpl', name: 'GNU General Public License Version 2'
License.create short_name: 'gpl-v3', license_type: 'gpl', name: 'GNU General Public License Version 3'

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

App.create(
  name: 'Fluidsynth',
  url: 'http://www.fluidsynth.org/',
  software_list: ['fluidsynth', 'qsynth'],
  file_format_list: ['sf2']
)

App.create(
  name: 'Timidity++',
  url: 'http://timidity.sourceforge.net/',
  software_list: ['linuxsampler', 'qsampler', 'fantasia'],
  file_format_list: ['gig', 'sf2', 'sfz']
)

# App.create(
#   name: 'Carla',
#   url: 'https://www.linuxsampler.org',
#   software_list: ['linuxsampler', 'qsampler', 'fantasia'],
#   file_format_list: ['gig', 'sf2', 'sfz']
# )

# Settings
settings = YAML.load(IO.read('config/settings.yml'))['settings']
Setting.create data: settings.remove_nesting!