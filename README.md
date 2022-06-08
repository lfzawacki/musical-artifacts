Musical Artifacts
---------------------------
Helping to catalog, preserve and free the artifacts you need to produce music.

[![Donate via Paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&amp;business=A5956UYMW6QKJ&amp;lc=US&amp;item_name=Musical%20Artifacts&amp;item_number=musart¤cy_code=USD&amp;bn=PP%2dDonationsBF%3abtn_donate_SM%2egif%3aNonHosted) [Donate via Paypal](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&amp;business=A5956UYMW6QKJ&amp;lc=US&amp;item_name=Musical%20Artifacts&amp;item_number=musart¤cy_code=USD&amp;bn=PP%2dDonationsBF%3abtn_donate_SM%2egif%3aNonHosted)

[![Travis Build](https://travis-ci.org/lfzawacki/musical-artifacts.svg?branch=master)](https://travis-ci.org/lfzawacki/musical-artifacts) [![Code Climate](https://codeclimate.com/github/lfzawacki/musical-artifacts/badges/gpa.svg)](https://codeclimate.com/github/lfzawacki/musical-artifacts) [![Test Coverage](https://codeclimate.com/github/lfzawacki/musical-artifacts/badges/coverage.svg)](https://codeclimate.com/github/lfzawacki/musical-artifacts/coverage) [![Security Checks](https://hakiri.io/github/lfzawacki/musical-artifacts/master.svg)](https://hakiri.io/github/lfzawacki/musical-artifacts/master) [![Docs](http://inch-ci.org/github/lfzawacki/musical-artifacts.svg?branch=master)](https://inch-ci.org/github/lfzawacki/musical-artifacts)

[Read the wiki](https://github.com/lfzawacki/musical-artifacts/wiki)

[Issue Board](https://trello.com/b/ExTElvLv/musical-artifacts)

# What?

Musical Artifacts is a web application with the objective of helping musicians find, share and preserve the 'artifacts' that they use for producing their music. It also aims to be a `de facto` guideline of how to best preserve these artifacts so that they're are useful to the biggest number of people possible.

# Why?

Artists want to work with art.
Musicians want to make music.

I had the idea of creating this application when I found myself struggling to find the samples I needed online and saw that some free music libraries that I had in my hard drive where now almost impossible to find anywhere. Let musicians find what they're looking for quicker so that they have more time to work on their craft.

Another big concern is to promote resources which are **free** but also use **open licenses** and are not restrictive of derivative works or distribution. Artists tend to be protective of their intelectual creations and more often than not want to limit the kind of uses or distribution that is made of it, which in turn creates situations where if the original creator is gone or doesn't care anymore his contributions could get lost in the ether of the web. That is why **open licensing** and **preserving** the artifacts is a vital part of this project.

# How?

This catalog is constructed abiding by the simple principle that a "musical artifact" is some kind of tool, file or idea which can be used to aid in the making of music, also it should preferably be distributed using a free (libre) license as to make it useful to the community at large. This usefulness is measured sequentially by these 5 simple steps. You can stop at any one of them, but the closer you get to the end the better:

1. Creation: You've created a musical artifact which can be used to aid in the process of music making. ([What constitutes a musical artifact](https://github.com/lfzawacki/musical-artifacts/wiki/Creating-a-new-artifact))

2. Access: You've made it accessible, available and usable to others in some fashion. ([How to host files?](https://github.com/lfzawacki/musical-artifacts/wiki/File-Hosting))

3. Licensing: You've licensed it using a free/libre license which is not restrictive of different uses, distribution and/or modification. ([Learn about open licenses](https://github.com/lfzawacki/musical-artifacts/wiki/Open-Licenses))

4. Open Format: You've made it available in an open or well documented file format which can be used by a good number of open source software. ([List of open formats](https://github.com/lfzawacki/musical-artifacts/wiki/Open-Formats))

5. Document it: You've crafted some kind of basic or advanced description of it's usage, technical details, tips n' tricks, and/or sample works created using it. ([Example of good documentation](#))

## Registering a new resource

Read more on the [Creating a new artifact](https://github.com/lfzawacki/musical-artifacts/wiki/Creating-a-new-artifact) wiki page.

Resources can be registered in the new artifact page in '/artifacts/new' and currently need to be approved by an admin before they appear on the index.

## API Access

The application URLS can be request in `json` format for consumption by other applications. Some examples:

    GET /artifacts.json # listing all artifacts

    GET /artifacts.json?q=guitar # artifacts resulting of a search for 'guitar'

    GET /artifacts/42.json # get the artifact with id 42

See the [API](https://github.com/lfzawacki/musical-artifacts/wiki/API-Documentation) for more examples and JSON object format or just make a search using the search bar and copy the URL using a JSON format.

### Development

For more details see the [Development page](https://github.com/lfzawacki/musical-artifacts/wiki/Development) on the wiki.

## Reporting a problem

### On a hosted file

Each file has a comment section and problems or additional information can be posted there.

### Dev

Bugs, feature requests, documentation enhancements and almost anything related to development goes on the [github issues page](https://github.com/lfzawacki/musical-artifacts/issues)

## Website Data

All the files and databases collected as part of the Musical Artifacts project can be downloaded from: <https://data.musical-artifacts.com>. There you'll find a database of all the artifacts, all the uploaded files as well as a json representation of all the data.

There's also [repository](https://github.com/nodiscc/musical-artifacts-data) for this json data if you like this kind of stuff.

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
  * [LMMS Sharing Platform](https://lmms.io/lsp/)

## Translations

  * FR translation by [Olivier Humbert](https://github.com/trebmuh)

## Resources

TODO: Thank all the artists/engineers/programmers who gave resources
