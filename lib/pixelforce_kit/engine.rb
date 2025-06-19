module PixelforceKit
  class Engine < ::Rails::Engine
    isolate_namespace PixelforceKit

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          ActiveRecord::Migrator.migrations_paths << expanded_path
        end
      end
    end
    
    initializer :initializer_ahoy do      
      require_relative 'initializer/ahoy'
    end

    if defined?(FactoryBotRails)
      config.factory_bot.definition_file_paths +=
        [File.expand_path('../../spec/factories', __dir__)]
    end
  end
end
