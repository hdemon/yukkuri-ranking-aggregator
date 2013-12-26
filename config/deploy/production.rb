set :stage, :production

set :ssh_options, {
  keys: %w(~/.ssh/id_rsa.yukkuri),
  forward_agent: true,
  auth_methods: %w(publickey)
}

# It assumes that we deploy application to virtual machine controled by vagrant.
# server '192.241.178.77', user: 'yukkuri', port: 22, roles: %w{web app}
server '192.168.33.11', user: 'yukkuri', port: 22, roles: %w{web app}

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
# and/or per server
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
# setting per server overrides global ssh_options

# fetch(:default_env).merge!(rails_env: :development)
