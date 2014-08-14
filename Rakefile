# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

#module ::Mhd
  #class Application
    #include Rake::DSL
  #end
#end

#module ::RakeFileUtils
  #extend Rake::FileUtilsExt
#end

Mhd::Application.load_tasks

begin
  require 'vlad'
  Vlad.load :scm => :git

  namespace :vlad do
    def rvm_setup
      # ya know, get to where we need to go
      # ex. /var/www/my_app/releases/12345
      goto_app_root = "cd #{'current'}"

      return "#{goto_app_root}"
    end

    # run bundle install with explicit path and without test dependencies
    remote_task :bundle do
      run "#{rvm_setup} && bundle install --deployment --without test"
    end

    task :update do
      Rake::Task['vlad:bundle'].invoke
    end

    #remote_task :dj_restart do
      #run "#{rvm_setup} && script/delayed_job restart"
    #end

    #remote_task :update_cron do
      #run "#{rvm_setup} && whenever --write"
    #end
    
    remote_task :unicorn_start do
      run "#{rvm_setup} && bundle exec unicorn -c /home/myhackerdiet/current/config/unicorn.rb -D"
    end

    remote_task :unicorn_restart do
      run "#{rvm_setup} && kill -QUIT `cat /home/myhackerdiet/shared/pids/myhackerdiet.pid`"
    end

    task :migrate do
      run "#{rvm_setup} && bundle exec rake db:migrate"
    end

    task :deploy do
      ['update', 'migrate', 'unicorn_restart'].each do |t|
        Rake::Task["vlad:#{t}"].invoke
      end
    end
  end


rescue LoadError => e
  puts "Unable to load Vlad #{e}."
end

