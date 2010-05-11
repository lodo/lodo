# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

Rake::Task["db:test:prepare"].enhance(['db:test:purge', 'db:schema:load']) do
  Rake::Task["db:test:prepare"].reenable
  Rake::Task["db:test:purge"].reenable
  Rake::Task["db:schema:load"].reenable
end

