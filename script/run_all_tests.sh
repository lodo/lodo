#! /bin/sh
cp config/database.yml.example config/database.yml
bundle install
rake test
