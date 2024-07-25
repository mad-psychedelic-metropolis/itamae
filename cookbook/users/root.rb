sshd_config = "/etc/ssh/sshd_config"

file sshd_config  do
    action :edit
    user "root"
    block do |content|
        content.gsub!(/^.*PermitRootLogin yes$/, "PermitRootLogin no")
        content.gsub!(/^.*PasswordAuthentication yes$/, "PasswordAuthentication no")
    end
end