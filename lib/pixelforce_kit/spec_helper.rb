# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'

require 'rails'
require 'active_record'
require 'action_controller/railtie'
require 'rspec/rails'
require 'devise'
require 'devise_token_auth'
require 'kaminari'
require 'jbuilder'
require 'ahoy_matey'
require 'factory_bot'
require 'fake_app'
require 'database_cleaner/active_record'
require 'net/http'
require 'webmock/rspec'

load "#{File.dirname(__FILE__)}/../../db/schema.rb"
ActiveRecord::Migration.verbose = false
ActiveRecord::MigrationContext.new(ActiveRecord::Migrator.migrations_paths).migrate

FactoryBot.definition_file_paths += [File.expand_path('../../spec/factories', __dir__)]

module AuthenticationHelpers
  def sign_in(user)
    if(user.is_a?(User))
      allow(controller).to receive(:current_user).and_return(user)
      allow(controller).to receive(:authenticate_user!).and_return(true)
    else
      allow(controller).to receive(:current_admin_user).and_return(user)
      allow(controller).to receive(:authenticate_admin_user!).and_return(true)
    end
  end

  def sign_out
    if(user.is_a?(User))
      allow(controller).to receive(:current_user).and_return(nil)
      allow(controller).to receive(:authenticate_user!).and_return(false)
    else
      allow(controller).to receive(:current_admin_user).and_return(nil)
      allow(controller).to receive(:authenticate_admin_user!).and_return(false)
    end
  end
end

RSpec.configure do |config|
  config.exclude_pattern = 'spec/integration/**/*_spec.rb'
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.render_views

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.include AuthenticationHelpers, type: :controller

  config.expect_with :rspec do |c|
    c.syntax = %i[should expect]
  end
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    FactoryBot.find_definitions
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end
end

RSpec::Matchers.define :equal_time do |expected|
  match do |actual|
    expected.to_i == actual.to_i
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :controller
end

RSpec::Expectations.configuration.on_potential_false_positives = :nothing

def travel_to(date_or_time)
  now = if date_or_time.is_a?(Date) && !date_or_time.is_a?(DateTime)
          date_or_time.midnight.to_time
        else
          date_or_time.to_time.change(usec: 0)
        end

  allow(Time).to receive(:now).and_return(Time.at(now.to_i))
  allow(DateTime).to receive(:now).and_return(Time.at(now.to_i))
  allow(Date).to receive(:today).and_return(now.to_date)
end

def travel(duration)
  travel_to Time.now + duration
end

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

class User < ApplicationRecord
end

class AdminUser < ActiveRecord::Base
end

class ApplicationController < ActionController::Base
  def get_search_params
    {}
  end
end