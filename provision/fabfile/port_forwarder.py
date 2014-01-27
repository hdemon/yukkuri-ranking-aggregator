from fabric.api import *
from fabric.contrib import *


class PortForwarder:
  @classmethod
  def map(self, host, mapped_to_container):
    command = "redir --lport %s --cport %s" % (host, mapped_to_container)
    sudobg(command)

  @classmethod
  def kill(self):
    for pid in self.current_pids():
      try:
        sudo("kill -kill %s" % pid)
      except:
        print

  @classmethod
  def current_pids(self):
    return sudo("ps aux|grep \"redir --lport\s\"| awk '{ print $2 }'").split("\r\n")

def sudobg(cmd, sockname="dtach"):
  return sudo('dtach -n `mktemp -u /tmp/%s.XXXX` %s'  % (sockname, cmd))
