set :application, 'barter.li'
set :repo_url, 'git@github.com:barterli/barter.li.git'
#SSHKit.config.command_map[:rake] = "bundle exec rake"

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# set :deploy_to, '/var/www/my_app'
set :deploy_to, '/home/deploy/barter.li'
# set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true
 set :linked_files, %w{config/database.yml config/application.yml}
 set :linked_dirs, %w{log tmp/backup tmp/pids tmp/cache tmp/sockets vendor/bundle}
 set :linked_dirs, fetch(:linked_dirs) + %w{public/system public/uploads}
 # linked_dirs = Set.new(fetch(:linked_dirs, [])) # https://github.com/capistrano/rails/issues/52
 # linked_dirs.merge(%w{bin log tmp/pids tmp/cache tmp/sockets public/system public/uploads})
 # set :linked_dirs, linked_dirs.to_a

# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
 set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
    task :restart do
      on roles(:app), in: :sequence, wait: 5 do
        # Your restart mechanism here, for example:
        # execute :mkdir, release_path.join('tmp') unless File.exists?(release_path.join('tmp'))
         execute :touch, release_path.join('tmp/restart.txt')
      end

  end
  
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
       within release_path do
           execute :rake, 'tmp:cache:clear'
       end
    end
  end

  # desc "Hot-reload God configuration for the thin"
  #   task :reload_god_config do
  #     god_config_path = File.join(release_path, 'config', 'thin.god')
  #     run "cd #{release_path}; bundle exec god stop && bundle exec god terminate &&  RAILS_ROOT=#{release_path} bundle exec god -c #{god_config_path}"
  #     # execute "god stop thin"
  #     # execute "god load #{File.join deploy_to, 'current', 'config', 'thin.god'}"
  #     # execute "god start thin"
  # end
 

  # after :deploy, 'deploy:reload_god_config'

  after :finishing, 'deploy:cleanup'

end




