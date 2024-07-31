require 'dotenv'
Dotenv.load

users = node[:users]
abort("undefined error: node[:users]") if users.nil?

users.each do |user| 
  username = user[:username]
  uid = user[:uid]
  passwd = user[:passwd]
  ssh_pubkey = user[:passwd]
  sudoers = user[:sudoers]
  makedir_home = user[:makedir_home]

  user "create_user_#{username}" do
    action :create
    user "root"
    uid uid
    username username
    password "#{password}".crypt("salt")
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
      content <<EOS
ssh_pubkey
EOS
    end
  end
end