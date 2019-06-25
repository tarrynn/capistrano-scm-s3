require "capistrano/scm/s3/version"
require "capistrano/scm/plugin"
require 'sshkit'
require 'sshkit/dsl'
include SSHKit::DSL

module Capistrano
  module Scm
    module S3
      class Plugin < ::Capistrano::SCM::Plugin
        def set_defaults
        end

        def define_tasks
          namespace :scm do
            namespace :s3 do
              task :create_release do
                on release_roles :all do
                  execute :mkdir, "-p", release_path
                  execute "mkdir /tmp/bootup"
                  execute "cd /tmp/bootup && aws s3 cp s3://bergamotte-deployments/codebuild/#{fetch :stage}/#{fetch :branch}_source.tar.gz #{fetch :branch}_source.tar.gz"
                  execute "cd /tmp/bootup && tar xvf #{fetch :branch}_source.tar.gz"
                  execute "mv /tmp/bootup/bergamotte/* #{release_path}"
                  execute "rm -rf /tmp/bootup"
                end
              end

              task :set_current_revision do
                set :current_revision, capture("cd #{release_path} && git rev-list --max-count=1 #{fetch :branch}")
              end
            end
          end
        end

        def register_hooks
          after "deploy:new_release_path", "scm:s3:create_release"
          before "deploy:set_current_revision", "scm:s3:set_current_revision"
        end
      end
    end
  end
end
