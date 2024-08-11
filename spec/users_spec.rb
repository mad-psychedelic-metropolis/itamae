require 'dotenv'
require './itamae/spec/helper/spec_helper'
Dotenv.load

users = node[:users]
conffile = "/etc/ssh/sshd_config"

users.each_with_index do |user,i|
    username = user[:username]
    uid = user[:uid]
    passwd = ENV["USER_#{uid}_PASSWORD"]
    ssh_pubkey = ENV["USER_#{uid}_SSH_PUBLIC"]
    sudoers = user[:sudoers]
    makedir_home = user[:makedir_home]

    describe user(username) do
        it { should exist }
        it { should have_uid user[:uid] }
        if makedir_home
            it { should have_home_directory '/home' }
            it { should have_authorized_key ssh_pubkey.to_s.dup }
            its(:encrypted_password) { should match(passwd.crypt("salt")) }
        end
    end

    if sudoers
        describe command("sudo su - -c 'whoami'") do
            let(:sudo_options) { "-u #{username} -i"}
            its(:exit_status) { should eq 0 }
            its(:stdout) { should match /^root$/ }
        end
    end
end

describe file(conffile) do
    it { should contain "PermitRootLogin no" }
    it { should contain "PasswordAuthentication no" }
end
