Artifact.create(
  name: 'Salamander Grand Piano v3',
  mirrors: ['http://freepats.zenvoid.org/Piano/SalamanderGrandPianoV3_48khz24bit.tar.bz2',
    'http://freepats.zenvoid.org/Piano/SalamanderGrandPianoV3_44.1khz16bit.tar.bz2',
    'http://freepats.zenvoid.org/Piano/SalamanderGrandPianoV3_OggVorbis.tar.bz2',
    'http://freepats.zenvoid.org/Piano/YamahaDisklavierPro-GrandPiano.tar.bz2',
    'https://archive.org/download/SalamanderGrandPianoV3/SalamanderGrandPianoV3.torrent'],
  author: 'Alexander Holm',
  description: '16 Velocity layers Sampled in minor thirds from the lowest A. Hammer noise releases chromatically sampled in onle one layer. String resonance releases in minor thirds in three layers. Two AKG c414 disposed in an AB position ~12cm above the strings',
  software_list: ['linuxsampler'],
  more_info_urls: ['http://freepats.zenvoid.org/Piano/'],
  tag_list: ['piano', 'sampled', 'sfz'],
  license_id: 2
)

Artifact.create(
  name: 'Salamander Drumkit v1',
  mirrors: ['https://archive.org/download/SalamanderDrumkit/salamanderDrumkit.tar.bz2', 'https://archive.org/download/SalamanderDrumkit/SalamanderDrumkit_archive.torrent', 'http://download.linuxaudio.org/musical-instrument-libraries/sfz/salamander_drumkit_v1.tar.7z'],
  author: 'Alexander Holm',
  description: 'A creative commons licensed drum library mapped with sfz.',
  software_list: ['linuxsampler'],
  tag_list: ['drums', 'drumkit', 'sfz', 'sampled'],
  more_info_urls: ['https://rytmenpinne.wordpress.com/salamander-drumkit/', 'http://www.kvraudio.com/forum/viewtopic.php?p=5329902'],
  license_id: 3
)

Artifact.create(
name: "Maestro Concert Grand v2",
description: "Maestro Concert Grand v2 is a big gig bank using 792 stereo samples of a concert piano, a Yamaha CF3 from the early 90s, It was chromatically sampled to maintain the tempered tuning. The samples were recorded with two Neumann KM84 microphones, disposed in X/Y, with 5 velocity layers, and weighs 932 MB ! The piano alone, without release samples, weighs 887 Mb and 440 samples. The release samples are 352 and weigh 45 MB. You can play with or without them.",
author: "Mats Helgesson",
mirrors:["http://download.linuxsampler.org/instruments/pianos/maestro_concert_grand_v2.rar"],
license_id: 9,
software_list: ['linuxsampler'],
tag_list: ['piano', 'sampled'],
file_format: 'sfz',
more_info_urls: ['http://linuxsampler.org/instruments.html', 'http://download.linuxsampler.org/instruments/pianos/maestro_concert_grand_v2_license.txt']
)

Artifact.create(
name: "TaijiguyGigaTron",
description: "The demo plays through each of the sounds in turn: \"M400 Violins\", \"M400 Violins Yes EQ\", \"M400 Violins Smooth Ryder EQ\", Cello, followed by demonstration of the five double-bass notes on the Cello sound, String Section, Mk II Strings, M300A (violins), M300B (solo violin), Mk II Brass, GC3 Brass, Mk II Flute, Woodwind2, Combined Choir. There then follows a demonstration of the low-pass filter, which is swept using the modwheel, using the \"M400 Violins\" sound. Notice the tapes running out: the Mellotron's seven or eight second note length is preserved as the samples are not looped. The filter is manipulated again briefly to find a nice setting, before playing a pad part using the \"M400 Violins\". The final part of the demo uses a short motif played with the filter fully open again, first on the \"M400 Violins\", then String Orchestra, M300A (violins), M300B (solo violin), Mk II Brass, GC3 Brass, Flute, Woodwind2 and finally Combined Choir. No processing of any kind was used, except Linuxsampler's in-built low-pass filter, where noted above.",
author: "Bernie Kornowicz (aka taijiguy)",
mirrors:["http://download.linuxsampler.org/instruments/vintage/TaijiguyGigaTron.tar.bz2"],
license_id: 9,
software_list: ['linuxsampler'],
tag_list: ['mellotron', 'vintage', 'sampled'],
file_format: 'gig',
more_info_urls: ['http://johngumpontheweb.com/Mellotron.html', 'http://linuxsampler.org/instruments.html', 'http://download.linuxsampler.org/instruments/vintage/TaijiguyGigaTron_demo.ogg']
)

Artifact.create(
name: "London Philharmonia Orchestra - Violin",
description: "",
author: "London Philharmonia Orchestra, Clement Guedez",
mirrors: ['http://download.linuxsampler.org/instruments/strings/philharmonia_violin_short.gig', 'http://download.linuxsampler.org/instruments/strings/philharmonia_violin_medium.gig'],
license_id: 9,
software_list: ['linuxsampler'],
tag_list: ['violin', 'orchestra'],
file_format: 'gig',
more_info_urls: ['http://linuxsampler.org/instruments.html']
)

Artifact.create(
name: "London Philharmonia Orchestra - Tuba",
description: "",
author: "London Philharmonia Orchestra, Clement Guedez",
mirrors: ['http://download.linuxsampler.org/instruments/brass/philharmonia_brass_tuba_long.gig', 'http://download.linuxsampler.org/instruments/brass/philharmonia_brass_tuba_medium.gig', 'http://download.linuxsampler.org/instruments/brass/philharmonia_brass_tuba_short.gig', 'http://download.linuxsampler.org/instruments/brass/philharmonia_brass_tuba_very_short.gig'],
license_id: 9,
software_list: ['linuxsampler'],
tag_list: ['tuba', 'orchestra'],
file_format: 'gig',
more_info_urls: ['http://linuxsampler.org/instruments.html']
)

# -------

Artifact.create(
name: "G-Town Church Sampling Project",
description: "Recorded in his local church in Grebbestad, Sweden by music producer Tobias Marberger, this set of CC-licensed music samples (available in two separate torrents, with either the original .WAV files with separate EXS24 soft sampler patches, or as .GIG Gigastudio-formatted versions) should be invaluable to amateur and professional musicians alike - includes anvil, snare, wood stick, hihat, brushplate, bongos, piano, organ, mandolin, glockenspiel, flute, many other instruments.",
author: "Tobias Marberger",
mirrors: [],
license_id: 8, # sample license
software_list: ['linuxsampler'],
tag_list: ['percussion', 'samples', 'church'],
file_format: 'gig',
more_info_urls: ['https://web.archive.org/web/20130913034913/http://www.clearbits.net/torrents/21-g-town-church-sampling-project', ]
)

Artifact.create(
name: "G-Town Church Sampling Project (kontakt)",
description: "Converted to kontakt format by mrwildbunnycat\n----------------------------\nRecorded in his local church in Grebbestad, Sweden by music producer Tobias Marberger, this set of CC-licensed music samples (available in two separate torrents, with either the original .WAV files with separate EXS24 soft sampler patches, or as .GIG Gigastudio-formatted versions) should be invaluable to amateur and professional musicians alike - includes anvil, snare, wood stick, hihat, brushplate, bongos, piano, organ, mandolin, glockenspiel, flute, many other instruments.",
author: "Tobias Marberger",
mirrors: ['https://www.dropbox.com/s/mp254g4hxmuhqyv/G-Town Church_KONTAKT.zip?dl=1'],
license_id: 8, # sample license
software_list: ['kontakt'],
tag_list: ['percussion', 'samples', 'church'],
file_format: 'nki',
file: File.open('./G-Town_Church_KONTAKT.zip'),
user: User.first,
more_info_urls: ['https://web.archive.org/web/20130913034913/http://www.clearbits.net/torrents/21-g-town-church-sampling-project', 'https://musical-artifacts.com/artifacts/77']
)

# Strange pipe stuff
# http://cdsol.com/samples.htm

desc = <<DESC
Here are some free samples from Starbirth Music for Gigastudio and other samplers. You may use them in any way you wish to make music either for your own use, or commercially, but you MAY NOT sell the samples, or include them in a compilation for samples for sale.

The first sample is for Gigastudio, and is a recording of traditional shofar calls played and recorded by Martin Schiff. You can download them here. Here are the details about the samples:

There are 3 different calls:

Tekiah - a long blast (varying lengths)
Shevarim - a wailing sound
Teruah - a broken trumpet sound

C4 - G4 - Tekiah (all notes, including half steps)
A5, B5 - Teruah
C5, D5 - Shevarim
E5 - low note
E6, E7 high note

 In addition, I have uploaded mp3 files of the 4 commonly used shofar calls.
Tekiah, Teruah, Shevarim and Tekiah Gedolah
DESC
Artifact.new(
name: "Tekiah, Shevarim, Teruah",
description: desc,
author: "Starbirth Music - Martin J. Schiff",
mirrors: ['http://www.cdsol.com/downloads/starbirth_kudu_shofar.zip'],
license_id: 'copyright',
software_list: ['linuxsampler'],
tag_list: ['horns' , 'samples'],
file_format: 'gig',
file: File.open('gig/starbirth_kudu_shofar.sf2'),
more_info_urls: ['http://cdsol.com/samples.htm']
)

# Soni Musicae (guy who doesnt like sharing of his stuff)
# http://sonimusicae.free.fr/accueil-en.html

Artifact.create(
name: "The Blanchet 1720",
description: "Using this soundbank in a sampler, you can play a virtual harpsichord copied after a 18th century french instrument by Blanchet. It has one manual, two 8' stops, plus a lute stop. This soundbank is available in soundfont, and Kontakt 2 format.",
author: "Soni Musicae",
mirrors: [],
license_id: 'copyright',
software_list: ['linuxsampler','carla', 'fluidsynth', 'timidity'],
tag_list: ['piano', 'samples', 'lute'],
file_format: 'sf2',
more_info_urls: ['http://sonimusicae.free.fr/blanchet1-en.html', 'http://sonimusicae.free.fr/accueil-en.html']
)

Artifact.create(
name: "The Small Italian",
description: "This is a soundbank of a harpsichord copied after an anonymous 17th century italian instrument. It has one manual, two 8' stops, plus a lute stop. It is suitable to play Renaissance and 17th century music.",
author: "Soni Musicae",
mirrors: [],
license_id: 'copyright',
software_list: ['linuxsampler','carla', 'fluidsynth', 'timidity'],
tag_list: ['harpsichord', 'samples'],
file_format: 'sf2',
more_info_urls: ['http://sonimusicae.free.fr/petititalien-en.html']
)

Artifact.create(
name: "Orgue de Salon (a house organ)",
description: "We are pleased to present you the bank of a small house organ, 250 pipes, 5 real stops on two manuals (plus a coupled keyboard), built in 1988. At first, we did not want to distribute it, because this is not an extraordinary organ, and it was impossible to avoid a big noise of organ-blower during the recording : as it is a house organ, it stood in a flat, and the microphones could not stand far from it. But, finally, after some numerical treatments, we think that the result is not so bad, and we give it to you as close as possible to the real thing, without changing many of its defaults...",
author: "Soni Musicae",
mirrors: [],
license_id: 'copyright',
software_list: ['linuxsampler','carla', 'fluidsynth', 'timidity'],
tag_list: ['organ', 'samples'],
file_format: 'sf2',
more_info_urls: ['http://sonimusicae.free.fr/orguedesalon-en.html']
)

Artifact.create(
name: "Diato : a diatonic accordion",
description: "Here is a sound bank of a small diatonic accordion, with 21 keys on two rows at the right hand, and 8 basses at the left, and a second stop that sounds lower. A diatonic accordion does not produce the same notes when you push or pull the bellows, and this makes this instrument not so easy to play... More, it has not all the semi-tones of its 3 octaves (from D2 to E5). With this sound bank, you can forget those drawbacks, because we have \"interpolated\" the missing notes, and all the notes are played in a same manner on a keyboard...",
author: "Soni Musicae",
mirrors: [],
license_id: 'copyright',
software_list: ['linuxsampler','carla', 'fluidsynth', 'timidity'],
tag_list: ['accordion'],
file_format: 'sf2',
more_info_urls: ['http://sonimusicae.free.fr/diato-en.html']
)

Artifact.create(
name: "The Ghent Carillon",
description: "This sf2 soundbank, called the Ghent Carillon, is made with free samples found on the following site :
http://bimbam.be/EN/klokken.html\nThey are mono but good sounding, and respect the resonance of the 54 bells, from B flat to F, on 4 octaves. The samples have been converted from mp3 to wave, and regularly disposed in space from left to right, using the pan adjustement in the soundfont with Vienna Soundfont.",
author: "Soni Musicae",
mirrors: [],
license_id: 'copyright',
software_list: ['linuxsampler','carla', 'fluidsynth', 'timidity'],
tag_list: ['bells', 'clock', 'samples'],
file_format: 'sf2',
more_info_urls: ['http://sonimusicae.free.fr/carillondegand-en.html', 'http://bimbam.be/EN/klokken.html']
)

Artifact.create(
name: "The Grandfather's Clock",
description: "This little soundbank gives you the grandfather's clock you ever dreamt of, and its true original tick-tack you need for suspense purpose. This clock has a special deep and heavy sound.",
author: "Soni Musicae",
mirrors: [],
license_id: 'copyright',
software_list: ['linuxsampler','carla', 'fluidsynth', 'timidity'],
tag_list: ['bells', 'clock', 'samples'],
file_format: 'sf2',
more_info_urls: ['http://sonimusicae.free.fr/carillondegand-en.html']
)

# sonatina

Artifact.create(
name: "Sonatina Symphonic Orchestra",
description: "Sonatina Symphonic Orchestra is a free orchestral sample library. While not as advanced or ambitious in scope as commercial offerings, SSO contains all the basic building blocks for creating real virtual orchestrations. It's primarily aimed at beginners, but also more experienced composers looking for something lightweight and/or portable might find it useful.",
author: "Mattias Westlund",
mirrors: ['http://tutorialsforreaper.com/wp-content/uploads/2011/01/SSO-sso.mattiaswestlund.com-SFZ-Samples.zip', 'http://www.bandcoach.org/mwsso/index.html', 'http://linux.autostatic.com/sso/sonatina-symphonic-orchestra-1.0.zip', 'http://arnout.engelen.eu/files/dev/linuxmusicians/sonatina/'],
license_id: 'cc-sample',
software_list: ['linuxsampler'],
tag_list: ['orchestra'],
file_format: 'sfz',
more_info_urls: ['http://sso.mattiaswestlund.net/']
)

# PAREI AQUI

# http://mattiaswestlund.net/?page_id=13    

# https://web.archive.org/web/20080221180532/http://worrasplace.com/

# http://www.tictokmen.com/sample/

Artifact.create(
name: "",
description: "",
author: "",
mirrors: [],
license_id: 9,
software_list: [],
tag_list: [],
file_format: 'gig',
more_info_urls: []
)

# https://web.archive.org/web/20070529182259/http://www.hum.aau.dk/~bovbjerg/piano4.html

# https://web.archive.org/web/20120228120423/http://www.boldersounds.net/free-sounds-c-22.html

# https://bb.linuxsampler.org/viewtopic.php?f=8&t=11&sid=a0624e5593c382de351c97fb101909d3

#

####################

Artifact.create(
name: "FS Ibanez Steel String Acoustic Guitar with Fender Reverb",
description: "An acoustic guitar suited to bluesy rhythms. Has quite alot of fret rattle with the high velocities but also a certain amount of mid to high frequencies which helps to give it its own place in a mix. You also have a choice of how much reverb you use just by using the mod wheel 2 (cc13) on certain presets. The reverb is a genuine old Fender Reverb unit. Which is a valve driven spring reverb. Not only is it a nice classic reverb but just putting the samples through it warms them up straight away. Mod wheel 1 (cc1) is the release. This is so that you can easily set the length of the notes as long as you need. Other presets include a fake twelve string (octave harmonies on each key), low pass filtered (for a more nylon guitar sound), split voices of muted fifths at one end and solo guitar at the other end of the keyboard (for quickly creating tunes and ideas) and alsorts of different combinations of presets to cover most options. The only two controllers you need for any of the presets are mod wheel 1 (cc1) and mod wheel 2 (cc13). The functions of these controllers are always part of the preset name.",
author: "FlameStudios",
mirrors: ['http://www.flamestudios.org/downloads/FS_Ibanez_Steel_String_Acoustic_Guitar_with_Fender_Reverb.tar.bz2'],
license: License.find('gpl'),
software_list: ['linuxsampler'],
tag_list: ['acoustic guitar', 'steel string', 'reverb', 'ibanez', 'sampled'],
file_format_list: ['gig', 'bz2'],
more_info_urls: ['http://www.flamestudios.org/free/GigaSamples']
)

Artifact.create(
name: "FS Seagull Steel String Acoustic Guitar with Fender Reverb",
description: "Another acoustic guitar. This one sounds nice for fingerpicking arrangements and in general has a steadier sound than the Ibanez. If I had to choose just one of the acoustic guitars it would be this one. This one has a much rounder and fuller sound than the Ibanez. Both guitars go well together as they have different sounds to each other. This giga sample also has the same presets as the one above. i.e. A choice of dry or with Fender Reverb etc.. Both guitar gigasamples have dry, reverb and reverb release samples.",
author: "FlameStudios",
mirrors: ['http://www.flamestudios.org/downloads/FS_Seagull_Steel_String_Acoustic_Guitar_with_Fender_Reverb.tar.bz2'],
license: License.find('gpl'),
software_list: ['linuxsampler'],
tag_list: ['acoustic guitar', 'steel string', 'reverb', 'seagull', 'sampled'],
file_format_list: ['gig', 'bz2'],
more_info_urls: ['http://www.flamestudios.org/free/GigaSamples']
)

Artifact.create(
name: "FS Washburn Acoustic Bass Guitar",
description: "This is a very rounded sounding electro-acoustic bass. Recorded straight without a mic, so there is no noise. This fits nicely with most types of music. Its deep but not overpowering, leaving room for other instruments. There is a choice of sample sets to choose from in this gigasample. Direct or through my j-station (which makes it sound more like its through an amp), or a mix somewhere between the two. The j-station samples are the same direct samples routed out and through the j-station and back in again, which is why it is possible to have a mix of the two. The same as what I did with the acoustic guitars and the reverb so as to control the level of the reverb.",
author: "FlameStudios",
mirrors: ['http://www.flamestudios.org/downloads/FS_Washburn_Acoustic_Bass_Guitar.tar.bz2'],
license: License.find('gpl'),
software_list: ['linuxsampler'],
tag_list: ['acoustic bass', 'bass', 'washburn', 'sampled'],
file_format_list: ['gig', 'bz2'],
more_info_urls: ['http://www.flamestudios.org/free/GigaSamples']
)

Artifact.create(
name: "FS Ibanez Electric Bass Guitar",
description: "This is a more muffled bass, suited for blending in or behind distorted guitars but useful for any situation when a bass sound without so much clarity is needed. It is also a much smaller file than the rest. Originally I made this just for my own personal use but decided it might be useful to others as it fits some pieces where the washburn bass doesn't. ",
author: "FlameStudios",
mirrors: ['http://www.flamestudios.org/downloads/FS_Ibanez_Electric_Bass_Guitar.tar.bz2'],
license: License.find('gpl'),
software_list: ['linuxsampler'],
tag_list: ['bass', 'ibanez', 'sampled'],
file_format_list: ['gig', 'bz2'],
more_info_urls: ['http://www.flamestudios.org/free/GigaSamples']
)

Artifact.create(
name: "FS Kay 5-String Banjo",
description: "A friend lent me this banjo and I got it working and sampled it. It's a 5 string closed back banjo. The fifth string being tuned to a high "g" note (half the length of the neck). Its this string and the closed back that helps give you the bluegrass sound (the high string ringing the "g" note throughout each of the chords with syncopated fingerpicking patterns). There are 2 presets in this giga sample. One is straight forward. Each note is sampled at different velocities, making it good for any tunes or midi files etc.. The other is set in a way to sound like its played the way a banjo player would play it, even if you do not know any banjo. Only five keys make any sound, but other keys change the notes that these keys play. It is set so that E-D# play all the major chords and then the next E-D# above that plays all the minor chords. On each of the chords the five keys are playing the five strings (with the right hand), while the left hand does its single finger chord changing. The first note is always the high "g". So if the chords do not go with this high "g" then you only play the other four notes (making it more like an irish banjo). You have to try it to see what I mean. With it set like this the right hand can concentrate on fingerpicking patterns (like picking the five strings) and the left changes the chord or you can loop the fingerpicking patterns all ready recorded and then just choose the chords. I have included some classic bluegrass banjo finger picking patterns as midi files. All you have to do is loop it and select the chords (or draw them in). Its addictive playing with this preset, creating crazy banjo finger picking sounds.",
author: "FlameStudios",
mirrors: ['http://www.flamestudios.org/downloads/FS_Kay_5-String_Banjo.tar.bz2'],
license: License.find('gpl'),
software_list: ['linuxsampler'],
tag_list: ['banjo', 'sampled'],
file_format_list: ['gig', 'bz2'],
more_info_urls: ['http://www.flamestudios.org/free/GigaSamples']
)

Artifact.create(
name: "FS Fender Jaguar Electric Both Pick-ups Guitar and Amp",
description: "This is a Japanese Fender Jaguar electric guitar played on the both pick-ups setting and is played through a Fender Bassman '59 Reissue with old valves in. This amp gives a really nice full clean sound. I have recorded it on the edge of break up so the low velocity samples come out clean and the high velocity samples come out with a bit of nataural power valve distortion. You can add more distortion with effects if you need it dirtier. It is hard to get this natural break up sound with effects which is why I have recorded it that way and if you add distortion it still has the natural bite of a valve amp (except with more distortion). This makes it very expressive just by the difference in tones at different played velocities. The lowest velocity is muted samples. Presets include split keyboard of muted 5ths at one end and solo guitar at the other end (good for jamming out tunes), muted samples preset, a fake 12-string (octave harmonies on each key), slaps and slides etc and a standard mapping. The sound is suited to a lot of types of music. These guitars have been used for all sorts of music over the years. It has not much sustain and makes a bright clean sound.",
author: "FlameStudios",
mirrors: ['http://www.flamestudios.org/downloads/FS_Collection_2/FS_Fender_Jaguar_Electric_Both_Pick-ups_Guitar_and_Amp.tar.bz2'],
license: License.find('gpl'),
software_list: ['linuxsampler'],
tag_list: ['guitar', 'fender', 'jaguar', 'sampled'],
file_format_list: ['gig', 'bz2'],
more_info_urls: ['http://www.flamestudios.org/free/GigaSamples']
)

Artifact.create(
name: "FS Fender Telecaster Both Pickups and Amp",
description: "This is an American Fender Telecaster electric guitar played on the both pick-ups setting and is played through a Fender Bassman '59 Reissue with old valves in. This gigasample has the same presets as the Fender Jaguar above and is also recorded with the volume on the edge of break up on the amp (read the Fender Jaguar above for description of amplifier setting). This guitar is suited to jangly indie sounds or clean country sounds but can be very rocky with more distortion added. This guitar is also a classic that has been used in alot of types of music.",
author: "FlameStudios",
mirrors: ['http://www.flamestudios.org/downloads/FS_Collection_2/FS_Fender_Telecaster_Both_Pickups_and_Amp.tar.bz2'],
license: License.find('gpl'),
software_list: ['linuxsampler'],
tag_list: ['guitar', 'fender', 'telecaster', 'sampled'],
file_format_list: ['gig', 'bz2'],
more_info_urls: ['http://www.flamestudios.org/free/GigaSamples']
)

Artifact.create(
name: "FS Gibson Les Paul Electric Both Pick-ups Guitar and Amp",
description: "This is an American Gibson Les Paul electric guitar played on the both pick-ups setting and is played through a Fender Bassman '59 Reissue with old valves in. This gigasample has the same presets as the Fender Jaguar above (except it does not include the slaps and slides preset) and is also recorded with the volume on the edge of break up on the amp (read the Fender Jaguar above for description of amplifier setting). This guitar is suited to jazz and blues but can easily be used for rock if used with more distortion. It has a very full rounded sound with good sustain and when played harder has a bite to the attack. This guitar is a classic that has been used in alot of types of music.",
author: "FlameStudios",
mirrors: ['http://www.flamestudios.org/downloads/FS_Collection_2/FS_Gibson_Les_Paul_Electric_Both_Pick-ups_Guitar_and_Amp.tar.bz2'],
license: License.find('gpl'),
software_list: ['linuxsampler'],
tag_list: ['les paul', 'gibson', 'guitar', 'sampled'],
file_format_list: ['gig', 'bz2'],
more_info_urls: ['http://www.flamestudios.org/free/GigaSamples']
)

Artifact.create(
name: "FS Percussion",
description: "The single keys at the beginning of the keyboard (C2-C3 white notes only) contain a variety of percussion instruments (2 wood blocks, an Irish bongo, a mini rain stick, a mini swinging drum, a tambourine, a mini hollow wood log and a mini wooden scraper). Then the black keys further up are groups of instruments that cut each other off. For instance the first group of black notes (F#3,G#3,A#3) are all samples from the big conga but with different hit types. The next 2 black notes are a dear skin bongo. The next 3 black notes are the little conga. The next 2 black notes are a little metal bongo. The next 3 black notes are the medium conga and the next 2 black notes are a home made plastic shaker. This makes it easy to know the grouped instruments. It is also easy to whack a way at the congas (like real congas) as they are all the black keys in groups of 3 and each conga cuts its own keys off if another is played. I mainly recorded this for the 3 congas and then added the other bits as I had them laying around (some are even from my childrens musical instruments bag, i.e. wood blocks from the early learning centre and a home made plastic shaker). The congas are boomy when played hard but with a lot more delicate hand sound when played softly. It is possible to get a variety of sounds and styles with these conga samples.",
author: "FlameStudios",
mirrors: ['http://www.flamestudios.org/downloads/FS_Collection_2/FS_Percussion.tar.bz2'],
license: License.find('gpl'),
software_list: ['linuxsampler'],
tag_list: ['percussion', 'wood block', 'bongo', 'conga', 'sampled'],
file_format_list: ['gig', 'bz2'],
more_info_urls: ['http://www.flamestudios.org/free/GigaSamples']
)

Artifact.create(
name: "FS Yamaha Electric Bass Guitar",
description: "This is a solid body bass guitar that has a full deep sound. There is not much middle to it which makes it less defined than a lot of basses but it does suit some music very well. There is a choice of sample sets to choose from in this gigasample. Direct or through my j-station (which makes it sound more like its through an amp), or a mix somewhere between the two. The j-station samples are the same direct samples routed out and through the j-station and back in again, which is why it is possible to have a mix of the two. The J-Station samples make a distorted beefy bass sound which can be useful for some music i.e. 3 piece bands where tha bass fills out instead of a rhythm guitar or just for a more lo-fi bass sound. The direct samples are not so distorted and can be used in alot more styles of music. You can use a mix of the direct and J-Station samples to get the balance of dirt just right on one of the presets (using mod wheel 2 or cc13). There is a preset that includes slaps and slides etc to help add some realism.",
author: "FlameStudios",
mirrors: ['http://www.flamestudios.org/downloads/FS_Collection_2/FS_Yamaha_Electric_Bass_Guitar.tar.bz2'],
license: License.find('gpl'),
software_list: ['linuxsampler'],
tag_list: ['bass', 'yamaha', 'sampled'],
file_format_list: ['gig', 'bz2'],
more_info_urls: ['http://www.flamestudios.org/free/GigaSamples']
)

Artifact.create(
name: "FS Fender Jaguar Electric Guitar Both Pickups Direct In",
description: "This is a Japanese Fender Jaguar recorded on the both pickups setting direct in and also through a valve driven Fender reverb unit. This can be used with software amplifiers such as the free fender and marshall vst plugins on this forum (there are lots of software guitar amplifier and pedal related things worth downloading on the Guitar Amp Modelling forum) or amplifier impulse response files with your convolution reverbs like Jconv on Linux or Freeverb on Windows. This giga sample also has presets that are through a Fender reverb unit. The reverb unit is designed to go before the amplifier so it is well suited to a direct in recording that is later going to be processed (i.e. put through a software amplifier). You also have a choice of how much reverb you use just by using the mod wheel 2 (cc13) on certain presets. Mod wheel 1 (cc1) is the release. This is so that you can easily set the length of the notes as long as you need. Other presets include a fake twelve string (octave harmonies on each key), low pass filtered, split voices of muted fifths at one end and solo guitar at the other end of the keyboard (for quickly creating tunes and ideas) and alsorts of different combinations of presets to cover most options. The only two controllers you need for any of the presets are mod wheel 1 (cc1) and mod wheel 2 (cc13). The functions of these controllers are always part of the preset name.",
author: "FlameStudios",
mirrors: ['http://www.flamestudios.org/downloads/FS_Collection_3/FS_Fender_Jaguar_Electric_Guitar_Both_Pickups_Direct_In.tar.bz2'],
license: License.find('gpl'),
software_list: ['linuxsampler'],
tag_list: ['guitar', 'fender', 'jaguar', 'sampled'],
file_format_list: ['gig', 'bz2'],
more_info_urls: ['http://www.flamestudios.org/free/GigaSamples']
)

Artifact.create(
name: "FS Fender Telecaster Electric Guitar Bridge Pickup Direct In",
description: "This is a Fender Telecaster recorded direct in using the bridge pickup (more treble than the neck pickup). It has the same presets as the Fender Jaguar Direct In above including Fender reverb samples also that can be mixed in with the mod wheel 2 on certain presets.",
author: "FlameStudios",
mirrors: ['http://www.flamestudios.org/downloads/FS_Collection_3/FS_Fender_Telecaster_Electric_Guitar_Bridge_Pickup_Direct_In.tar.bz2'],
license: License.find('gpl'),
software_list: ['linuxsampler'],
tag_list: ['guitar', 'fender', 'telecaster', 'sampled'],
file_format_list: ['gig', 'bz2'],
more_info_urls: ['http://www.flamestudios.org/free/GigaSamples']
)

Artifact.create(
name: "FS Fender Telecaster Electric Guitar Neck Pickup Direct In",
description: "This is a Fender Telecaster recorded direct in using the neck pickup (more bass than the bridge pickup). It has the same presets as the Fender Jaguar Direct In above including Fender reverb samples also that can be mixed in with the mod wheel 2 on certain presets.",
author: "FlameStudios",
mirrors: ['http://www.flamestudios.org/downloads/FS_Collection_3/FS_Fender_Telecaster_Electric_Guitar_Neck_Pickup_Direct_In.tar.bz2'],
license: License.find('gpl'),
software_list: ['linuxsampler'],
tag_list: ['guitar', 'fender', 'telecaster', 'sampled'],
file_format_list: ['gig', 'bz2'],
more_info_urls: ['http://www.flamestudios.org/free/GigaSamples']
)

Artifact.create(
name: "FS Gibson Les Paul Bridge Pick-Up Electric Guitar Direct In",
description: "This is a Gibson Les Paul recorded direct in using the bridge pickup (more treble than the neck pickup). It has the same presets as the Fender Jaguar Direct In above including Fender reverb samples also that can be mixed in with the mod wheel 2 on certain presets.",
author: "FlameStudios",
mirrors: ['http://www.flamestudios.org/downloads/FS_Collection_3/FS_Gibson_Les_Paul_Bridge_Pick-Up_Electric_Guitar_Direct_In.tar.bz2'],
license: License.find('gpl'),
software_list: ['linuxsampler'],
tag_list: ['les paul', 'gibson', 'guitar', 'sampled'],
file_format_list: ['gig', 'bz2'],
more_info_urls: ['http://www.flamestudios.org/free/GigaSamples']
)

Artifact.create(
name: "FS Gibson Les Paul Neck Pick-Up Electric Guitar Direct In",
description: "This is a Gibson Les Paul recorded direct in using the neck pickup (more bass than the bridge pickup). It has the same presets as the Fender Jaguar Direct In above including Fender reverb samples also that can be mixed in with the mod wheel 2 on certain presets.",
author: "FlameStudios",
mirrors: ['http://www.flamestudios.org/downloads/FS_Collection_3/FS_Gibson_Les_Paul_Neck_Pick-Up_Electric_Guitar_Direct_In.tar.bz2'],
license: License.find('gpl'),
software_list: ['linuxsampler'],
tag_list: ['les paul', 'gibson', 'guitar', 'sampled'],
file_format_list: ['gig', 'bz2'],
more_info_urls: ['http://www.flamestudios.org/free/GigaSamples']
)


# ------------------ Karoryfer

