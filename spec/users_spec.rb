require 'dotenv'
require './itamae/spec/helper/spec_helper'
Dotenv.load

users = node[:users]
conffile = "/etc/ssh/sshd_config"

users.each_with_index do |user,i|
    username = user[:username]
    password = "#{ENV["USER_#{i+1}_PASSWORD"]}"

    describe user(username) do
        it { should exist }
        it { should have_uid user[:uid] }
        it { should belong_to_group 'wheel' }
        it { should have_home_directory '/home' }
        it { should have_authorized_key user[:sshkey] }
        its(:encrypted_password) { should match("#{password}") }
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
