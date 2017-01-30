# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'menu_ad_hoc_bot'
set :repo_url, 'git@github.com:YeasterEgg/menu_ad_hoc_bot.git'
set :deploy_to, '/var/www/menu_ad_hoc_bot'
set :log_level, :info
set :keep_releases, 2

role :app, "root@46.101.114.92"
role :web, "root@46.101.114.92"

set :branch, ENV["BRANCH"] || 'master'

set :scm, :git

after :"deploy:finished", :change_ownership do
  on roles(:web) do
    execute "sudo chown -R www-data:www-data #{release_path}/"
  end
end

after :change_ownership, :copy_dotenv do
  on roles(:web) do
    execute "ln -ns #{shared_path}/.env #{current_path}/."
  end
end

after :copy_dotenv, :restart_puma do
  on roles(:web) do
    execute "touch #{current_path}/tmp/restart.txt"
  end
end
