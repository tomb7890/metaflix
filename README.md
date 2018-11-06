Metaflix
==============================

[![Build Status](https://travis-ci.org/tomb7890/metaflix.svg?branch=master)](https://travis-ci.org/tomb7890/metaflix)


Metaflix is a Rails application that maintains an up-to-date list of the latest movies to appear on a popular movie streaming site that meet a quality threshold. The quality threshold is determined by using IMDB's rating score and Metacritic's Metascore.

#### CONFIGURATION


#### REQUIREMENTS
 - Mechanize
 - Httparty


#### USAGE

Fetch the latest movies into the database by running `rake fetch:new_movies`, perhaps on a daily basis using cron or some kind of scheduled automation.

Launch the site by running `rails`.

#### TODO




----------------
