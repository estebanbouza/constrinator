require_relative "./organization/list"

module Google
  module Cloud
    module ResourceManager

      class Organization

        ##
        # @private The Service object.
        attr_accessor :service

        ##
        # @private The Google API Client object.
        attr_accessor :gapi

        attr_accessor :effective_org_policies

        attr_writer :cached_sub_folders

        attr_accessor :cached_sub_projects

        ##
        # @private Create an empty Project object.
        def initialize
          @service    = nil
          @gapi       = Google::Cloud::ResourceManager::Service::API::Organization.new
        end

        def name
          @gapi.name
        end

        def id
          @gapi.name.match(/organizations\/([0-9]*)/)[1]
        end

        def self.from_gapi gapi, service
          new.tap do |p|
            p.gapi = gapi
            p.service = service
          end
        end

        def get_effective_org_policy constraint 
          effective_org_policy = (@effective_org_policies ||= {})[constraint]

          unless effective_org_policy
            ensure_service!
            effective_org_policy = service.get_organization_effective_org_policy name, constraint
            @effective_org_policies[constraint] = effective_org_policy
          end
          effective_org_policy
        end

        def sub_folders
          unless @cached_sub_folders
            ensure_service!
            @cached_sub_folders = service.folders(parent: name, max: 100).all
            @cached_sub_folders.each { |x| x.parent = self }
          end

          @cached_sub_folders
        end

        def sub_projects
          unless @cached_sub_projects
            ensure_service!
            @cached_sub_projects = service.projects(filter: "parent.id:#{id}").all.to_a
          end

          @cached_sub_projects
        end

        def recursive_calculate target_constraints, depth = 0
          puts "#{__callee__}.#{__method__} Processing #{name}"
          constraints = target_constraints.map { |x| get_effective_org_policy(x) }
          sub_projects&.map { |p| p.recursive_calculate(target_constraints, depth + 1) }
          sub_folders&.map { |f| f.recursive_calculate(target_constraints, depth + 1) }
          constraints
        end

        def recursive_print depth = 0
          @effective_org_policies.each do |op|
            pad = "  " * depth
            puts "#{pad}├#{self.name} | #{op}"
          end
          sub_projects&.each { |f| f.recursive_print(depth + 1)}
          sub_folders&.each { |p| p.recursive_print(depth + 1)}
        end

        protected

        ##
        # Raise an error unless an active service is available.
        def ensure_service!
          raise "Must have active connection" unless service
        end

      end
    end
  end
end