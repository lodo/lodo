
namespace "db" do
  namespace "test" do
    desc "Load blueprints into test db"
    task "load_blueprints" => ["environment", "db:test:prepare"] do
      RAILS_ENV="test"
      require 'test/blueprints'
      config = Rails::Configuration.new
      ActiveRecord::Base.connection.execute("vacuum analyze") if config.database_configuration["test"]["adapter"] == "postgresql"
    end
  end
end

