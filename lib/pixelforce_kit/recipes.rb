require "pixelforce_kit/version"
require "capistrano"

Dir[File.expand_path("#{File.dirname(__FILE__)}/recipes/capistrano_recipes/*.rb")].each {|file| require file }