#! /bin/sh

BD=/home/lodo

# Chatty
set -x

# Exit on error
set -e

export HOME=$BD
cp config/database.yml.example config/database.yml
bundle install
rake db:create
rake db:migrate
rake test:units
rake test:functionals

