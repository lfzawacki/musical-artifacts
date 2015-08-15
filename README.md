Musical Artifacts
---------------------------
Helping to catalogue, preserve and free the artifacts you need to produce music.

[![](https://travis-ci.org/lfzawacki/musical-artifacts.svg?branch=master)](https://travis-ci.org/lfzawacki/musical-artifacts) [![](https://codeclimate.com/github/lfzawacki/musical-artifacts/badges/gpa.svg)](https://codeclimate.com/github/lfzawacki/musical-artifacts) [![](https://hakiri.io/github/lfzawacki/musical-artifacts/master.svg)](https://hakiri.io/github/lfzawacki/musical-artifacts/master) [![](http://inch-ci.org/github/lfzawacki/musical-artifacts.svg?branch=master)](https://inch-ci.org/github/lfzawacki/musical-artifacts) [Read the docs](https://github.com/lfzawacki/musical-artifacts/wiki)

# What?

TODO: `This is a guide, a proof of concept, a catalogue, a tool to be used by musicians, sound engineers and programmers`

# Why?

TODO: `Don't repeat ourselves, don't be slaves to any specific tool, music is subjective, creativity is cool, culture of freedom and sharing, battle against copyright but by giving people something better in it's place.`

# How?

This catalogue is constructed abiding by the simple principle that a "musical artifact" is some kind of tool, file or idea which can be used to aid in the making of music, also it should preferably be distributed using a free (libre) license as to make it useful to the community at large. This usefulness is measured sequentially by these 5 simple steps. You can stop at any one of them, but the closer you get to the end the better:

1. Creation: You've created a musical artifact which can be used to aid in the process of music making. ([What constitutes a musical resource](#))

2. Access: You've made it accessible, available and usable to others in some fashion. ([How to host files?](https://github.com/lfzawacki/musical-artifacts/wiki/File-Hosting))

3. Licensing: You've licensed it using a free/libre license which is not restrictive of different uses, distribution and/or modification. ([Learn about open licenses](https://github.com/lfzawacki/musical-artifacts/wiki/Open-Licenses))

4. Open Format: You've made it available in an open or well documented file format which can be used by a good number of open source software. ([List of open formats](https://github.com/lfzawacki/musical-artifacts/wiki/Open-Formats))

5. Document it: You've crafted some kind of basic or advanced description of it's usage, technical details, tips n' tricks, and/or sample works created using it. ([Example of good documentation](#))

## Searching

By using the search bar in the main artifact page.

`TODO explain advanced search`

## API Access

The application URLS can be request in `json` format for consumption by other applications. Some examples:

    GET /artifacts.json # listing all artifacts

    GET /artifacts.json?q=guitar # artifacts resulting of a search for 'guitar'

    GET /artifacts/42.json # get the artifact with id 42

See the [API](https://github.com/lfzawacki/musical-artifacts/wiki/API-Documentation) for more examples and JSON object format or just make a search using the search bar and copy the URL using a JSON format.

### Limits

TODO: `Explain public API limits.`

### Authenticated access

TODO: `Exlpain how to authenticate api calls and get a bigger access limit.`

## Registering a new resource

Resources can be registered in the new artifact page in '/artifacts/new'

### Development

For more details see the [Development page](https://github.com/lfzawacki/musical-artifacts/wiki/Development) on the wiki.

#### Setting up a dev environment

##### Dependencies

    rails4.2 ruby2.1.2 postrgresql >= 9.3 postrgresql-contrib >= 9.3

##### Install gems

    bundle install

##### Crate and seed the database

First copy the example settings file:

    cp config/settings.yml.example config/settings.yml

Make some modifications in the file before seeding the database if you want. Then run:

    bundle exec rake db:reset

##### Run the server

    bundle exec rails s

#### Tests

To run tests type:

    bundle exec rake

Before sending a patch or pull request remember to run the tests and add new ones.

Tests live inside the `tests/` directory and use the [minitest](http://blowmage.com/minitest-rails) and [capybara](http://blowmage.com/minitest-rails-capybara/) frameworks.

## Reporting a problem

### On a hosted file

Each file has a comment section and problems or additional information can be posted there.

### Dev

Bugs, feature requests, documentation enhancements and almost anything related to development goes on the [github issues page](https://github.com/lfzawacki/musical-artifacts/issues)

# Credits

## Open Source Projects

  * Ruby on Rails + libraries, see gemfile
  * [Juvia](https://github.com/phusion/juvia) for comments
  * [Piwik](http://piwik.org/) for analytics

## Art/Graphics

  * [The pretty flat icons](http://www.elegantthemes.com/blog/freebie-of-the-week/beautiful-flat-icons-for-free)
  * [The pretty theme](http://startbootstrap.com/template-overviews/freelancer/)

## Related projects / Inspirations

  * [The Internet Archive](https://archive.org/)
  * [CC Mixter](http://ccmixter.org/)
  * [Freesound](https://www.freesound.org/)

## Resources

TODO: Thank all the artists/engineers/programmers who gave resources
