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
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
 set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
       execute :mkdir, release_path.join('tmp')
       execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
       within release_path do
        execute :rake, 'tmp:cache:clear'
        execute :rake, 'tmp:db:migrate'
       end
    end
  end

  after :finishing, 'deploy:cleanup'

end
