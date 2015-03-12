require 'ruboty/igudhizu/version'
require 'ruboty/igudhizu/override'
require 'ruboty/igudhizu/word'
require 'ruboty/igudhizu/splitter'
require 'ruboty/igudhizu/learner'
require 'ruboty/igudhizu/paragraph_builder'

require 'ruboty/handlers/igudhizu_talk'
require 'ruboty/handlers/igudhizu_reply'
require 'ruboty/handlers/igudhizu_following'

module Ruboty
  module Igudhizu
    def self.init
      return if @init
      @init = true

      ENV['MONGOID_ENV'] ||= 'development'
      Mongoid.load!(mongoid_config_path)
    end

    def self.mongoid_config_path
      ENV['MONGOID_CONFIG_PATH'] || File.expand_path('../../../mongoid.yml', __FILE__)
    end
  end
end
