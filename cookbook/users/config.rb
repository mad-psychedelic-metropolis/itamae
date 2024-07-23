require 'dotenv'
Dotenv.load

users = node[:users]

abort("undefined error: node[:users]") if users.nil?

users.each do |user| 
  user "create user" do
    action :create
    uid user[:uid]
    username user[:username]
    password "#{ENV["USER_1_PASSWORD"]}"
  end

  directory "/home/#{user[:username]}/.ssh" do
    owner user[:username]
    group user[:username]
    mode "700"
  end

  file "/home/#{user[:username]}/.ssh/authorized_keys" do
    content user[:sshkey]
    owner user[:username]
    group user[:username]
    mode "600"
  end

  if user[:sudoers]
    execute "add user to sudoers" do
      user "root"
      command "usermod -G wheel #{user[:username]}"
    end
  end
end