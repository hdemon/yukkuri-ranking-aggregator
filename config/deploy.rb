set :application, 'yukkuri-crawler'
set :scm, :git
set :repo_url, 'git@bitbucket.org:hdemon/yukkuri-crawler.git'
set :branch, 'private-master'
set :deploy_to, '/home/yukkuri/yukkuri-crawler'
set :rbenv_ruby, '2.1.0'
# it required to execute bundle command with rbenv env
# see http://stackoverflow.com/questions/19716131/usr-bin-env-ruby-no-such-file-or-directory-using-capistrano-3-capistrano-rben
set :bundle_flags, ''
set :default_env, { path: "~/rbenv/shims:~/rbenv/bin:$PATH" }
set :whenever_roles, :web


namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  task :migrate do
    on roles(:web) do
      execute "echo #{release_path}"
      within release_path do
        execute "mkdir /home/yukkuri/log -p"
        execute "cd /home/yukkuri/yukkuri-crawler/current && ( PATH=~/rbenv/shims:~/rbenv/bin:$PATH bundle exec rake db:migrate ENV=production )"
        # execute :rake, "db:migrate"
      end
    end
  end

  after :finishing, 'deploy:cleanup'
  after 'deploy:published', 'deploy:migrate'
end
