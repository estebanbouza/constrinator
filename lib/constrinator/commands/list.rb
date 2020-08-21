# frozen_string_literal: true

require_relative '../command'
require "google/cloud/resource_manager"
require "vendor/resource_manager/manager"
require "constrinator"

module Constrinator
  module Commands
    class List < Constrinator::Command

      attr_accessor :target_constraints
      attr_accessor :root_resource

      def initialize(options)
        @options = options        
      end

      def gcp_rm_client
        gcp_rm = ::Google::Cloud::ResourceManager.new
      end

      def logger str
        @output.puts "[DEBUG] #{str}"
      end

      def execute(input: $stdin, output: $stdout)
        @output = output
        logger "Options: #{@options}"
        @root_resource = @options["root_resource"]
        @root_resource = root_resource_from @root_resource
        desired_target_constraints = @options["target_constraints"]&.split(",")

        logger "Using root resource: #{@root_resource.name}"
        @target_constraints = calculate_target_constraints @root_resource, desired_target_constraints
        
        @root_resource.recursive_calculate @target_constraints.map { |x| x["name"] }
        @root_resource.recursive_print

      end

      def calculate_target_constraints root_resource, desired_target_constraints
        available = gcp_rm_client.list_available_constraints @root_resource.name
        if desired_target_constraints
          available.select! { |x| desired_target_constraints.include?(x["name"])}
        end
        raise Constrinator::Error.new("Can't find any constraint: #{desired_target_constraints}") if available.empty?

        available
      end

      def root_resource_from input_root_resource
        root_resource = nil
        if input_root_resource.nil?
          weird_org = gcp_rm_client.organizations.first
          root_resource = gcp_rm_client.organization weird_org.name
        elsif input_root_resource.match? /organizations\/.*/
          root_resource = gcp_rm_client.organization input_root_resource
        elsif input_root_resource.match? /folders\/.*/
          root_resource = gcp_rm_client.folder input_root_resource
        end

        root_resource
      end

    end
  end
end
