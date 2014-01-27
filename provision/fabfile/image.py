from fabric.api import *
from fabric.contrib import *
import datetime
from container import Container


class Image:
  def __init__(self, repository_name, dockerfile_path):
    self.tag = None
    self.repository_name = repository_name
    self.dockerfile_directory = "/".join(dockerfile_path.split("/")[::-1][1:][::-1])

  def build(self):
    self.tag = self.timestamp()
    sudo("docker build -no-cache -t %s:%s %s" % (self.repository_name, self.tag, self.dockerfile_directory))

  def run(self, port_maps=None):
    port_forwarding_options = ""

    if port_maps != None:
      print port_maps
      for map in port_maps:
        if map.get("host") == None:
          port_forwarding_options += "-p %s " % map["container"]
        else:
          port_forwarding_options += "-p %s:%s " % (map["host"], map["container"])

    container_id = sudo("docker run -i -d -t %s %s:%s" % (port_forwarding_options, self.repository_name, self.tag))

    return Container(container_id)

  def timestamp(self):
    return datetime.datetime.today().strftime("%Y%m%d%H%M%S")

  def image_id(self):
    return sudo("docker images|grep -E \"^%s\s+%s\"|awk '{print $3}'" % (self.repository_name, self.tag))

  def container_id(self):
    id_array = sudo("docker ps -a|grep %s:%s|awk '{print $1}'" % (self.repository_name, self.tag)).split("\r\n")

    if len(id_array) == 0:
      return None
    elif len(id_array) == 1:
      return id_array[0]
    else:
      return id_array

  # @classmethod
  # def container_ids_of(self, image_id_or_repository_name):
  #   id_array = sudo("docker ps -a|grep %s|awk '{print $1}'" % image_id_or_repository_name).split("\r\n")

  #   if len(id_array) == 0:
  #     return None
  #   elif len(id_array) == 1:
  #     return id_array[0]
  #   else:
  #     return id_array

  @classmethod
  def image_id_of(self, repository_name, tag = None):
    if tag == None:
      return sudo("docker images|grep -E \"^%s\"|awk '{print $3}'" % (repository_name)).split('\r\n')
    else:
      return sudo("docker images|grep -E \"^%s\s+%s\"|awk '{print $3}'" % (repository_name, tag)).split('\r\n')[0]
