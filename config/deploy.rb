set :application, "myhackerdiet"
set :repository,  "jon@horder.digital-drip.com:/home/jon/git/myhackerdiet.git"
set :user, 'myhackerdiet'
set :revision, 'origin/master'

task :production do
  set :domain, 'myhackerdiet@clinton.digital-drip.com'
  set :deploy_to, '/home/myhackerdiet'

  set :thin_socket, '/tmp/myhackerdiet.sock'

  set :web_command, ''
end

task :staging do
  set :domain, 'mhd@hoover.digital-drip.com'
  set :deploy_to, '/home/mhd'

  set :thin_socket, '/tmp/mhd.sock'

  set :web_command, ''
end

