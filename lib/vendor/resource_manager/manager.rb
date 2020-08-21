require_relative "./service"
require_relative "./organization"
require_relative "./folder"
require_relative "./project"

module Google
  module Cloud
    module ResourceManager
      class Manager

        def organizations filter: nil, token: nil, max: nil
          gapi = service.search_organizations filter: nil, token: nil, max: nil
          Organization::List.from_gapi gapi, self, filter, max
        end

        def organization name
          gapi = service.get_organization name
          Organization.from_gapi gapi, self
        end

        def folders parent: nil, token: nil, max: nil
          gapi = service.list_folders parent: parent, token: token, max: max
          Folder::List.from_gapi gapi, self, parent, max
        end

        def folder name
          gapi = service.get_folder name
          Folder.from_gapi gapi, self
        end

        def list_available_constraints resource
          gapi = service.list_available_constraints resource
          JSON.parse(gapi.to_json).dig("constraints").map do |x|
            x.select { |c| c != "description" }
          end
        end

        def get_organization_effective_org_policy org_name, constraint
          gapi = service.get_organization_effective_org_policy org_name, constraint
          JSON.parse(gapi.to_json)
        end

        def get_folder_effective_org_policy resource, constraint
          gapi = service.get_folder_effective_org_policy resource, constraint
          JSON.parse(gapi.to_json)
        end

        def get_project_effective_org_policy project, constraint
          gapi = service.get_project_effective_org_policy project, constraint
          JSON.parse(gapi.to_json)
        end

      end

    end
  end
end