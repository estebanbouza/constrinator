# frozen_string_literal: true

require 'thor'

module Constrinator
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    desc 'version', 'constrinator version'
    def version
      require_relative 'version'
      puts "v#{Constrinator::VERSION}"
    end
    map %w(--version -v) => :version

    desc 'list', 'List all the constraints applied for all visible resources'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    method_option :root_resource, aliases: '--root-resource', type: :string,
                         desc: 'Use this root resource, e.g folder/12345 organization/12345 projects/acme-project'
    method_option :target_constraints, aliases: '--target-constraints', type: :string,
                         desc: 'Analyze only those comma sepparated target resources. E.g. constraints/compute.requireOsLogin,constraints/compute.disableSerialPortAccess	'
        
    def list(*)
      if options[:help]
        invoke :help, ['list']
      else
        require_relative 'commands/list'
        Constrinator::Commands::List.new(options).execute
      end
    end
  end
end
