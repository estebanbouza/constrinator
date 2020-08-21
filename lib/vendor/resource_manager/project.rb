module Google
  module Cloud
    module ResourceManager


      class Project

        attr_accessor :effective_org_policies

        def resource_name
          "projects/#{project_id}"
        end

        def get_effective_org_policy constraint 
          effective_org_policy = (@effective_org_policies ||= {})[constraint]

          unless effective_org_policy
            ensure_service!
            effective_org_policy = service.get_project_effective_org_policy resource_name, constraint
            @effective_org_policies[constraint] = effective_org_policy
          else
            effective_org_policy
          end
        end

        def recursive_calculate target_constraints, depth = 0
          pad = "├  " * depth
          puts "#{pad}Analizing project #{resource_name}"

          constraints = target_constraints.map { |x| get_effective_org_policy(x) }
          constraints
        end

        def recursive_print depth = 0
          idx = 0
          pad = "  " * depth

          @effective_org_policies.each do |key, value|
            if idx == 0
              puts "#{pad}├ Project: #{self.name}\n#{pad}    #{value}"
            else
              puts "#{pad}    #{value.to_json}"
            end

            idx += 1
          end

          nil
        end

      end

    end
  end
end