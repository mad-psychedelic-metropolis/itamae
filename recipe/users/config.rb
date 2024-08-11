require 'dotenv'
Dotenv.load

users = node[:users]
abort("undefined error: node[:users]") if users.nil?

users.each do |user| 
  username = user[:username]
  uid = user[:uid]
  passwd = ENV["USER_#{uid}_PASSWORD"]
  ssh_pubkey = ENV["USER_#{uid}_SSH_PUBLIC"]
  sudoers = user[:sudoers]
  makedir_home = user[:makedir_home]

  user "create_user_#{username}" do
    action :create
    user "root"
    uid uid
    username username
    password passwd.crypt("salt")
    home "/home/#{username}"
  end

  if makedir_home
    directory "/home/#{user[:username]}/.ssh" do
      user "root"
      owner user[:username]
      group user[:username]
      mode "700"
    end

    file "/home/#{user[:username]}/.ssh/authorized_keys" do
      user "root"
      owner user[:username]
      group user[:username]
      mode "600"
      content ssh_pubkey
    end
  end

  if sudoers
    sudo_config = "Defaults:#{username} !requiretty\n"
    sudo_config << "%#{username} ALL=(ALL) NOPASSWD: ALL"

    file "/etc/sudoers.d/#{username}" do
      action :create
      mode   "440"
      owner  "root"
      group  "root"
      content sudo_config
    end
  end
end