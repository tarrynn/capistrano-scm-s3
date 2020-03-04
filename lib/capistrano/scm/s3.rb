require "capistrano/scm/s3/version"
require "capistrano/scm/plugin"

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
                  execute "cd /tmp/bootup && aws s3 cp #{fetch :scm_s3_bucket}/#{fetch :stage}/#{fetch :branch}_source.tar.gz #{fetch :branch}_source.tar.gz"
                  execute "cd /tmp/bootup && tar xf #{fetch :branch}_source.tar.gz"
                  execute "mv /tmp/bootup/#{fetch :application}/* #{release_path}"

                  # by default mv doesn't move hidden files, so we're explicitly moving them as well
                  execute "mv /tmp/bootup/#{fetch :application}/.[!.]* #{release_path}"
                  execute "rm -rf /tmp/bootup"
                end
              end

              task :set_current_revision do
                on release_roles :all do
                  revision = capture(:cat, "#{release_path}/.git/HEAD")
                  set(:current_revision, revision)
                end
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
