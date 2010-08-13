namespace "db" do
  namespace "test" do
    desc "Load blueprints into test db"
    task "load_blueprints" => ["environment", "db:test:prepare"] do
      raise "set RAILS_ENV=test before running task" unless Rails.env == "test"
      require 'test/blueprints'
      #config = Rails::Configuration.new
      #ActiveRecord::Base.connection.execute("vacuum analyze") if config.database_configuration["test"]["adapter"] == "postgresql"
    end
  end
end


namespace "db" do
  namespace "test" do
    desc "Load bulk data into test db"
    task "load_bulk" => ["environment", "db:test:prepare"] do
      raise "set RAILS_ENV=test before running task" unless Rails.env == "test"
      $BULK_APPEND = false
      $BULK_SALARY = false
      require 'test/bulkdata'
    end
  end
end

namespace "db" do
  namespace "test" do
    desc "Load additional bulk data into test db"
    task "append_bulk" => ["environment"] do
      raise "set RAILS_ENV=test before running task" unless Rails.env == "test"
      $BULK_APPEND = true
      $BULK_SALARY = false
      require 'test/bulkdata'
    end
  end
end

namespace "db" do
  namespace "test" do
    desc "Load salary information into test db"
    task "append_salary" => ["environment"] do
      raise "set RAILS_ENV=test before running task" unless Rails.env == "test"
      $BULK_APPEND = true
      $BULK_SALARY = true
      require 'test/bulkdata'
    end
  end
end

