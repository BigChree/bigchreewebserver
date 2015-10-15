# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'bigchree.com'
set :repo_url, 'https://github.com/BigChree/bigchreewebserver.git'

set :user, "chris"
set :deploy_via, :copy
set :rails_env, "production"
#set :ssh_options, { :forward_agent => true, :port => 4321 }
server "99.15.81.35", roles: %w{app db web}, :primary => true

set :ssh_options, {
    user: 'chris', # overrides user setting above
    #keys: %w(C:\Users\Chris Taylor\.ssh\bigchree_rsa),
    forward_agent: true,
    port: 4321
    #auth_methods: %w(publickey password)
    # password: 'please use keys'
	}
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

desc "Symlink shared config files"
task :symlink_config_files do
    run "#{ try_sudo } ln -s #{ deploy_to }/shared/config/database.yml #{ current_path }/config/database.yml"
    run "#{ try_sudo } ln -s #{ deploy_to }/shared/config/secrets.yml #{ current_path }/config/secrets.yml"
end

after "deploy", "deploy:symlink_config_files"

