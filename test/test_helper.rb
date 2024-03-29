# frozen_string_literal: true

require "simplecov"
SimpleCov.start "rails" do
  add_filter "/app/channels/"
  add_filter "/app/jobs/"
  add_filter "/app/mailers/"
end

require "mocha/minitest"
Minitest::Reporters.use!

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

DatabaseCleaner.strategy = :transaction
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    # Choose a test framework:
    with.test_framework :minitest

    with.library :rails
  end
end

if ENV["CI"] == "true"
  require "codecov"
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    # fixtures :all
    include FactoryBot::Syntax::Methods

    # Add more helper methods to be used by all tests here...
    def before_setup
      super
      DatabaseCleaner.start
    end

    def after_teardown
      super
      DatabaseCleaner.clean
      Rails.cache.clear
    end
  end
end
