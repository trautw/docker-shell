# From https://github.com/ChristianKniep/docker-icinga.git

user_name = ENV['USER']
$user_name = user_name
$app_name = "docker-shell"
$data_container = "#{$app_name}data"
$data_container_name = "#{user_name}-#{$data_container}"
$server_image = "#{user_name}/#{$app_name}"
$data_image = "#{user_name}/#{$data_container}"
$data_volumes = "/home/#{user_name}"
$docker = ". ../env.source; docker"

$domain = "docker.szz.chtw.de"
$env = "dev"
$port = "9080"

# Name skydns
$dns = "172.17.0.2"

class Default < Thor
  include Thor::Actions

  desc 'restart','All in one'
  def restart
    run "thor image_build"
    run "thor container_kill"
    run "thor container_start"
    run "thor show_samplecall"
  end

  # Data
  desc 'dataimage_build', 'Create data container'
  def dataimage_build
    run "#{$docker} build -t #{$data_image} - <<EOM
FROM busybox
MAINTAINER Christoph Trautwein \"<christoph.trautwein@sinnerschrader.com>\"

RUN mkdir -p /home/#{$user_name}
RUN chmod 755 /home/#{$user_name}

VOLUME /home/#{$user_name}
EOM"
    run "#{$docker} run --name #{$data_container_name} #{$data_image} /bin/true"
  end

  desc 'dataimage_destroy', 'Destructive destroy of data container'
  def dataimage_destroy
    run "#{$docker} rm #{$data_container_name}"
  end

  desc 'dataimage_backup', 'Create tar of data in container'
  def dataimage_backup
    run "#{$docker} run --rm --volumes-from #{$data_container_name} busybox tar cf - #{data_volumes} | gzip > $HOME/4backup/#{$data_container}_`date '+%w'`.tz", verbose: false
    run "#{$docker} run --rm --volumes-from #{$data_container_name} busybox tar cf - #{$data_volumes} | gzip > $HOME/4backup/#{$data_container}_`date '+%U'`.tz", verbose: false
  end

  desc 'dataimage_restore', "Restore data in container from #{$data_container}.tz"
  def dataimage_restore
    run "zcat #{$data_container}.tz | #{$docker} run -i --rm --workdir / --volumes-from #{$data_container_name} busybox tar xvf -", verbose: false
    run "#{$docker} run --rm --volumes-from #{$data_container_name} busybox chown -R default:default #{$data_volumes}", verbose: false
  end

  desc 'dataimage_shell', 'Shell to data container'
  def dataimage_shell
    run "#{$docker} run --interactive=true --tty=true --rm --volumes-from #{$data_container_name} busybox /bin/sh"
  end

  # Server
  desc 'image_build','Create the server image'
  def image_build
    run "#{$docker} build -t #{$server_image} ."
  end

  desc 'container_start', "run #{$app_name}"
  def container_start
    run "#{$docker} run --hostname #{$app_name} --volumes-from #{$data_container_name} --interactive=true --tty=true --rm --workdir=/home/#{$user_name} #{$server_image}"
  end

  desc 'container_start_nodata', "run #{$app_name}"
  def container_start_nodata
    run "#{$docker} run --hostname #{$app_name} --interactive=true --tty=true --rm --workdir=/home/#{$user_name} #{$server_image}"
  end

  desc 'container_kill', 'Kill server'
  def container_kill
    # run "#{$docker} stop #{$app_name}"
    # run "#{$docker} kill #{$app_name}"
    # run "#{$docker} rm   #{$app_name}"
  end

  desc 'show_samplecall', "show how to use #{$app_name}"
  def show_samplecall
    docker_host = `. ../env.source;echo $DOCKER_HOST`.split('/')[2].split(':')[0]
    # puts "Try: http://icingaadmin:admin@#{docker_host}:#{$port}/icinga/"
  end

end

