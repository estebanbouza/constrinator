require_relative "./folder/list"

module Google
  module Cloud
    module ResourceManager

      class Folder

        ##
        # @private The Service object.
        attr_accessor :service

        ##
        # @private The Google API Client object.
        attr_accessor :gapi

        attr_accessor :effective_org_policies

        attr_accessor :cached_sub_folders

        attr_accessor :cached_sub_projects

        attr_accessor :parent

        ##
        # @private Create an empty Folder object.
        def initialize
          @service = nil
          @gapi = Google::Apis::CloudresourcemanagerV2::Folder.new
        end

        def name
          @gapi.name
        end

        def id
          @gapi.name.match(/folders\/([0-9]*)/)[1]
        end

        def display_name
          @gapi.display_name
        end

        def parent
          @gapi.parent
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
            effective_org_policy = service.get_folder_effective_org_policy name, constraint
            @effective_org_policies[constraint] = effective_org_policy
          else
            effective_org_policy
          end
        end

        def sub_folders
          unless @cached_sub_folders
            ensure_service!
            @cached_sub_folders = service.folders(parent: name, max: 100).all.to_a
            @cached_sub_folders.each { |x| x.parent = self }
            @cached_sub_folders
          end

          @cached_sub_folders
        end

        def sub_projects          
          unless @cached_sub_projects
            ensure_service!
            @cached_sub_projects = service.projects(filter: "parent.id:#{id}").all.to_a
            # @cached_sub_projects.each { |x| x.parent = self }
            @cached_sub_projects.each { |x| x.service = service }
          end

          @cached_sub_projects
        end

        def recursive_calculate target_constraints, depth = 0
          pad = "├  " * depth
          puts "#{pad}Analyzing folder #{name} #{display_name}"

          constraints = nil
          if true
            constraints = target_constraints.map { |x| get_effective_org_policy(x) }
          end

          sub_folders&.map { |f| f.recursive_calculate(target_constraints, depth + 1) }
          sub_projects&.map { |p| p.recursive_calculate(target_constraints, depth + 1) }
          
          constraints
        end

        def recursive_print depth = 0
          idx = 0
          pad = "  " * depth

          @effective_org_policies.each do |key, value|
            if idx == 0
              puts "#{pad}├ Folder: #{self.display_name}\n#{pad}    #{value.to_json}"
            else
              puts "#{pad}    #{value.to_json}"
            end

            idx += 1
          end

          sub_projects&.each { |p| p.recursive_print(depth + 1)}
          sub_folders&.each { |f| f.recursive_print(depth + 1)}

          nil
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