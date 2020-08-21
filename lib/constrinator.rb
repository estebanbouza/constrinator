require "constrinator/version"
require "google/cloud/resource_manager"
require "vendor/resource_manager/manager"
require "logger"


module Constrinator
  class Error < StandardError; end

  class ConstrinatorLogger 
    attr_reader :logger
    
    def initialize
      @logger = Logger.new $stdout
      @logger.level = Logger::DEBUG
    end

  end

  class Error < StandardError; end

end
