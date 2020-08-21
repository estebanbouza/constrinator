require "google/apis/cloudresourcemanager_v2"
require "pry"

module Google
  module Cloud
    module ResourceManager
      class Service

        def service_v2
          return @service_v2 if @service_v2

          @service_v2 = Google::Apis::CloudresourcemanagerV2::CloudResourceManagerService.new
          # @service_v2 = API::CloudResourceManagerService.new
          @service_v2.client_options.application_name = \
            "gcloud-ruby"
          @service_v2.client_options.application_version = \
            Google::Cloud::ResourceManager::VERSION
          # @service_v2.client_options.open_timeout_sec = timeout
          # @service_v2.client_options.read_timeout_sec = timeout
          # @service_v2.client_options.send_timeout_sec = timeout
          # @service_v2.request_options.retries = retries || 3
          @service_v2.request_options.header ||= {}
          @service_v2.request_options.header["x-goog-api-client"] = \
            "gl-ruby/#{RUBY_VERSION} " \
            "gccl/#{Google::Cloud::ResourceManager::VERSION}"
          @service_v2.authorization = @credentials.client
          # @service_v2.root_url = 'https://cloudresourcemanager.googleapis.com/'
          @service_v2
        end

        def search_organizations filter: nil, token: nil, max: nil
          execute do
            service.search_organizations 
          end
        end

        def get_organization_effective_org_policy org_name, constraint
          execute do
            request_body = Google::Apis::CloudresourcemanagerV1::GetEffectiveOrgPolicyRequest.new
            request_body.constraint = constraint
            
            service.authorization = Google::Auth.get_application_default(['https://www.googleapis.com/auth/cloud-platform'])
        
            org_policy = service.get_organization_effective_org_policy org_name, request_body
          end
        end

        def list_folders parent: nil, token: nil, max: nil
          execute do
            service_v2.list_folders parent: parent, page_token: token, page_size: max
          end
        end

        def get_folder_effective_org_policy resource, constraint
          execute do
            request_body = Google::Apis::CloudresourcemanagerV1::GetEffectiveOrgPolicyRequest.new
            request_body.constraint = constraint
            
            service.authorization = Google::Auth.get_application_default(['https://www.googleapis.com/auth/cloud-platform'])
        
            service.get_folder_effective_org_policy resource, request_body
          end
        end

        def get_project_effective_org_policy project, constraint
          execute do
            request_body = Google::Apis::CloudresourcemanagerV1::GetEffectiveOrgPolicyRequest.new
            request_body.constraint = constraint
            
            service.authorization = Google::Auth.get_application_default(['https://www.googleapis.com/auth/cloud-platform'])
        
            service.get_project_effective_org_policy project, request_body
          end
        end

        
        def list_available_constraints resource
          result = nil
          if resource.match?(/organization.*/)
            request_body = Google::Apis::CloudresourcemanagerV1::ListAvailableOrgPolicyConstraintsRequest::Representation
            service.list_organization_available_org_policy_constraints resource, request_body
          elsif resource.match?(/folder.*/)
            request_body = Google::Apis::CloudresourcemanagerV1::ListAvailableOrgPolicyConstraintsRequest::Representation
            service.list_folder_available_org_policy_constraints resource, request_body
          else
            request_body = Google::Apis::CloudresourcemanagerV1::ListAvailableOrgPolicyConstraintsRequest::Representation
            service.list_project_available_org_policy_constraints resource, request_body
          end
        end 

        def get_organization name
          service.get_organization name
        end

        def get_folder name
          service_v2.get_folder name
        end

      end
    end
  end
end