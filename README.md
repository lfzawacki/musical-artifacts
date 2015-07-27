Musical Artifacts
---------------------------
Helping to catalogue, preserve and free the artifacts you need to produce music.

![](https://travis-ci.org/lfzawacki/musical-artifacts.svg?branch=master) ![](https://codeclimate.com/github/lfzawacki/musical-artifacts/badges/gpa.svg) ![](https://hakiri.io/github/lfzawacki/musical-artifacts/master.svg) ![](http://inch-ci.org/github/lfzawacki/musical-artifacts.svg?branch=master)

# What?

TODO: `This is a guide, a proof of concept, a catalogue, a tool to be used by musicians, sound engineers and programmers`

# Why?

TODO: `Don't repeat ourselves, don't be slaves to any specific tool, music is subjective, creativity is cool, culture of freedom and sharing, battle against copyright but by giving people something better in it's place.`

# How?

This catalogue is constructed abiding by the simple principle that a "musical artifact" is some kind of tool, file or idea which can be used to aid in the making of music, also it should preferably be distributed using a free (libre) license as to make it useful to the community at large. This usefulness is measured sequentially by these 5 simple steps. You can stop at any one of them, but the closer you get to the end the better:

1. Creation: You've created a musical artifact which can be used to aid in the process of music making. ([What constitutes a musical resource](#))

2. Access: You've made it accessible, available and usable to others in some fashion. ([How to host files?](#))

3. Licensing: You've licensed it using a free/libre license which is not restrictive of different uses, distribution and/or modification. ([Learn about open licenses](#))

4. Open Format: You've made it available in an open or well documented file format which can be used by a good number of open source software. ([List of open formats](#))

5. Document it: You've crafted some kind of basic or advanced description of it's usage, technical details, tips n' tricks, and/or sample works created using it. ([Example of good documentation](#))

## Searching

By using the search bar in the main artifact page.

## API Access

The application URLS can be request in `json` format for consumption by other applications. Some examples:

    GET /artifacts.json # listing all artifacts

    GET /artifacts.json?q=guitar # artifacts resulting of a search for 'guitar'

    GET /artifacts/42.json # get the artifact with id 42

See the [API](#) for more examples and JSON object format or just make a search using the search bar and copy the URL using a JSON format.

### Limits

TODO: `Explain public API limits.`

### Authenticated access

TODO: `Exlpain how to authenticate api calls and get a bigger access limit.`

## Registering a new resource

TODO: `As of right now, resource registration is done by the admins only.`

### Development

#### Setting up a dev environment

Dependencies: `rails4.2 postrgresql >= 9.3 postrgresql-contrib >= 9.3`

#### Running tests

  `TODO: Write more tests`
  bundle exec rake

## Reporting a problem

### On a hosted file

Each file has a comment section and problems or additional information can be posted there.

### Dev

Bugs, feature requests, documentation enhancements and almost anything related to development goes on the [github issues page](https://github.com/lfzawacki/musical-artifacts/issues)

# Credits

## Open Source Projects

  * See gemfile
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

Thank all the artists/engineers/programmers who gave resources
