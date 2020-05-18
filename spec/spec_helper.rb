require "bundler/setup"
require "rails_i18n_extended"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

end

I18n.available_locales = [:en, :fr, :de]
I18n.load_path << File.dirname(__FILE__) + '/locales/en.yml'
I18n.load_path << File.dirname(__FILE__) + '/locales/fr.yml'
I18n.load_path << File.dirname(__FILE__) + '/locales/de.yml'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

load File.dirname(__FILE__) + '/schema.rb'

class Model < ActiveRecord::Base
  enum test_enum_attribute: { enum_key: 'enum_key' }
end
