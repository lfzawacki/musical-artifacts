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
  name: 'Clean Guitar with Reverb',
  mirrors: ['http://lfzawacki.com/clean.gx', 'http://lfzawacki2.com/clean.gx'],
  author: 'kokoko3k',
  description: 'Clean and trebley guitar sound drenched with lots of reverb',
  software_list: ['guitarix'],
  tag_list: ['preset', 'guitar','clean', 'reverb', 'rock'],
  license_id: 'gpl',
)

Artifact.create(
  name: 'Clean Guitar with Reverb',
  mirrors: ['http://lfzawacki.com/clean.gx', 'http://lfzawacki2.com/clean.gx'],
  author: 'Lucas Fialho Zawacki',
  description: 'Clean and trebley guitar sound drenched with lots of reverb',
  software_list: ['guitarix'],
  tag_list: ['preset', 'guitar','clean', 'reverb', 'rock'],
  license_id: 'gpl'
)


Artifact.create(name: "FunkyBluesRock", mirrors: ['http://guitarix.sourceforge.net/forum/download/file.php?id=40&sid=ac0ab1ba5bce8ec8ad4929da06d42a2a'], author: "ThaGiz", description: "Hi all I hope this preset will suit someone, I mainly use it for practice since it can handle a lot of styles I like. It's been long overdue but here you go, have fun!", software_list: ['guitarix'], tag_list: ['preset', 'guitar', 'rock', 'funky', 'blues', 'metal'], license_id: 1, file: File.open('./files/Linuxmuso.gx'), user: User.first)
Artifact.create(name: "Bass-like guitar", author: "guitarixtuner", description: "", software_list: ['guitarix'], tag_list: ['preset', 'guitar', 'bass'], license_id: 1, file: File.open('/home/lucas/Downloads/Linuxmuso.gx'))

Artifact.create(
name: "Funkmuscle Guitarix Bank",
description: "One of the old preset banks included with Guitarix.  Contains the following presets:\n\n  * mesa\n  * mesa2\n  * bluz\n  * jazz\n  * jazz2\n  * Texas\n  * MarsMesa\n  * JrBoogie\n\n-------------------\nConverted to the newer version by kokoko3k.",
author: "Funkmuscle",
license: License.find('gpl-v2'),
software_list: ['guitarix'],
tag_list: ['bank', 'preset', 'mesa boogie', 'jazz', 'blues', 'guitar', 'clean'],
file: File.open('./files/funkmuscle.gx'),
user: User.first
)

Artifact.create(
name: "Zettberlin Guitarix Bank",
description: "One of the old preset banks included with Guitarix.  Contains the presets:\n\n  * fatbrett\n  * kystallik\n\n-------------------\nConverted to the newer version by kokoko3k.",
author: "zettberlin",
license: License.find('gpl-v2'),
software_list: ['guitarix'],
tag_list: ['bank', 'preset', 'fuzz', 'clean', 'guitar'],
file: File.open('./files/zettberlin.gx'),
user: User.first
)

Artifact.create(
name: "kokoko3k Guitarix Bank",
description: "One of the old preset banks included with Guitarix. Contains:\n\n  * Dist1\n  * Dist2\n  * OverSharp\n  * Metal\n  * Chorus Clean\n  * The King\n  * Straits-fingers\n  * Bass... FAT!\n\n",
author: "kokoko3k",
license: License.find('gpl-v2'),
software_list: ['guitarix'],
tag_list: ['bank', 'preset', 'distortion', 'metal', 'chorus', 'bass', 'guitar', 'clean'],
file: File.open('./files/kokoko3k.gx'),
user: User.first
)

Artifact.create(
name: "JP Guitarix Bank",
description: "One of the old preset banks included with Guitarix. Really heavy and crunchy metal tones here and also a good lead preset. Contains:\n\n  * HighGainSolo\n  * HighGainRythm1\n  * CleanTone\n  * HidhGainRythm2\n  * Clean_Support\n\n-------------------\nConverted to the newer version by kokoko3k.",
author: "JP",
license: License.find('gpl-v2'),
software_list: ['guitarix'],
tag_list: ['bank', 'preset', 'distortion', 'metal', 'distortion', 'high gain', 'guitar', 'clean', 'lead'],
file: File.open('./files/JP.gx'),
user: User.first
)

Artifact.create(
name: "StudioDave Guitarix Bank",
description: "One of the old preset banks included with Guitarix.  Contains:\n\n  * dlp-wahtootsie\n  * dlp-verbchor-1\n  * dlp-clean-m21\n  * dlp-princeverb\n  * dlp-verbchor-2\n  * dlp-clean-twin\n  * dlp-bright-ac\n  * dlp-sweet-echo\n  * dlp-princeton-chorus\ndlp-m21-flangechor\n\n-------------------\nConverted to the newer version by kokoko3k.",
author: "StudioDave",
license: License.find('gpl-v2'),
software_list: ['guitarix'],
tag_list: ['bank', 'preset', 'flanger', 'clean', 'guitar', 'reverb'],
file: File.open('./files/StudioDave.gx'),
user: User.first
)