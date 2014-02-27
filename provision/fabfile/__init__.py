import datetime
import os
import yaml
from fabric.api import *
from fabric.contrib import *

from image import Image
from container import Container
from port_forwarder import PortForwarder

env.use_ssh_config = True


def deploy():
  image = build_web_app_image()
  container = image.run(port_maps=[{"container": 80}, {"container": 443}])

  PortForwarder.kill()
  for map in container.port_maps():
    PortForwarder.map(host=map["container_ip"], mapped_to_container=map["host_port"])


def build_basement_image():
  source_file = './provision/templates/Dockerfile-basement'
  destination_file = './tmp/Dockerfile'

  run("mkdir -p ./tmp")
  files.upload_template(source_file, destination_file, mode=0777)

  image = Image("basement", destination_file)
  image.build()
  run("rm -rf ./tmp")
  return image


def build_mysql_image():
  config = yaml.load(open('../config/crawler.yml').read().decode('utf-8'))

  context = { "parent_image_id": Image.image_id_of("basement")[0], "root_password": config["root_password"] }
  source_file = './provision/templates/Dockerfile-mysql'
  destination_file = './tmp/Dockerfile'

  run("mkdir -p ./tmp")
  files.upload_template(source_file, destination_file, mode=0777)

  image = Image("mysql", destination_file)
  image.build()
  run("rm -rf ./tmp")
  return image


def build_web_basement_image():
  context = { "parent_image_id": Image.image_id_of("basement")[0] }
  source_file = './provision/templates/Dockerfile-web-server'
  destination_file = './tmp/Dockerfile'

  run("mkdir -p ./tmp")
  files.upload_template(source_file, destination_file, context=context, mode=0777)
  files.upload_template("./templates/nginx/default", "./tmp/default", mode=0644)
  files.upload_template("./templates/nginx/default-ssl", "./tmp/default-ssl", mode=0644)

  image = Image("web-basement", destination_file)
  image.build()
  run("rm -rf ./tmp")
  return image


def build_web_app_image():
  context = { "parent_image_id": Image.image_id_of("web-basement")[0], "port_maps": [{container: 80}, {container: 443}] }
  source_file = './provision/templates/Dockerfile-web-app'
  destination_file = './tmp/Dockerfile'

  run("mkdir -p ./tmp")
  files.upload_template(source_file, destination_file, context=context, mode=0777)

  image = Image("web-app", destination_file)
  image.build()
  run("rm -rf ./tmp")
  return image


def remove_all_images():
  remove_all_containers_of(repository_name)
  sudo('docker rmi $(sudo docker images -q)')

def remove_images_without_latest_one(repository_name):
  for image_id in Image.image_id_of(repository_name)[1:]:
    sudo("docker rmi %s" % (image_id))

def remove_images(repository_name, tag = None):
  for image_id in Image.image_id_of(repository_name, tag):
    remove_all_containers_of(repository_name, tag)
    sudo("docker rmi %s" % (image_id))

def remove_all_containers():
  sudo('docker rm $(sudo docker ps -a -q)')

def remove_all_containers_of(repository_name, tag):
  try:
    sudo('docker rm $(sudo docker ps -a | grep %s | awk \'{ print $1 }\')' % repository_name)
  except:
    print
  return


def timestamp():
  return datetime.datetime.today().strftime("%Y%m%d%H%M%S")


def install_docker():
  sudo("sh -c \"wget -qO- https://get.docker.io/gpg | apt-key add -\"")
  sudo("sh -c \"echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list\"")
  sudo("apt-get update -y")
  sudo("apt-get upgrade -y")

  sudo("""
    apt-get install -y \
      sudo \
      man-db \
      wget \
      git \
      nano \
      curl \
      dialog \
      net-tools \
      patch \
      gcc \
      openssl \
      make \
      bzip2 \
      autoconf \
      automake \
      libtool \
      bison
  """)

  sudo("""
    apt-get install -y \
      linux-image-generic-lts-raring \
      linux-headers-generic-lts-raring \
      lxc-docker
  """)
