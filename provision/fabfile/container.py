from fabric.api import *
from fabric.contrib import *
import json


class Container:
  def __init__(self, container_id):
    self.container_id = container_id
    self.info = json.loads(sudo("docker inspect %s" % self.container_id).rstrip())[0]

  def stop(self):
    sudo("docker stop %(self.container_id)s")

  def start(self):
    sudo("docker start %(self.container_id)s")

  def remove(self):
    sudo("docker rm %(self.container_id)s")

  def network_settings(self):
    return self.info["NetworkSettings"]

  def ip_address(self):
    return self.network_settings()["IPAddress"]

  def port_maps(self):
    ports = self.network_settings()["Ports"]
    array = []

    keys = ports.keys()

    for key in keys:
      dic = {
        "host_port": ports[key][0]["HostPort"],
        "host_ip": ports[key][0]["HostIp"],
        "container_ip": key.split("/")[0]
      }
      array.append(dic)

    return array
