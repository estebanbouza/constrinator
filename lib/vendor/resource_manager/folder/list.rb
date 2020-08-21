require "delegate"

module Google
  module Cloud
    module ResourceManager
      class Folder
        class List < DelegateClass(::Array)

          attr_accessor :token

          def initialize arr = []
            super arr
          end

          def next?
            !token.nil?
          end

          def next
            return nil unless next?
            ensure_manager!
            @manager.folders token: token, parent: @parent, max: @max
          end

          def all request_limit: nil
            request_limit = request_limit.to_i if request_limit
            unless block_given?
              return enum_for :all, request_limit: request_limit
            end
            results = self
            loop do
              results.each { |r| yield r }
              if request_limit
                request_limit -= 1
                break if request_limit < 0
              end
              break unless results.next?
              results = results.next
            end
          end

          def self.from_gapi gapi_list, manager, parent, max = nil
            folders = new(Array(gapi_list.folders).map do |gapi_object|
              gapi_object.define_singleton_method(:type) { "folder" }
              gapi_object.define_singleton_method(:id) { gapi_object.name.match(/folders\/([0-9]*)/)[1] }
              
             Folder.from_gapi gapi_object, manager
            end)

            folders.instance_variable_set :@token,   gapi_list.next_page_token
            folders.instance_variable_set :@manager, manager
            folders.instance_variable_set :@parent,  parent
            folders.instance_variable_set :@max,     max
            folders
          end

          protected

          ##
          # Raise an error unless an active connection is available.
          def ensure_manager!
            raise "Must have active connection" unless @manager
          end
        end

      end
    end
  end
end