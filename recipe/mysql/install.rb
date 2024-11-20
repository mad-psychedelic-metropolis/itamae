mysql = node[:mysql]

execute "mysql84-community-release-el9-1.noarch.rpm" do
    command "rpm -Uvh https://dev.mysql.com/get/mysql84-community-release-el9-1.noarch.rpm
    "
    not_if "rpm -qa | grep mysql84-community-release-el9-1"
end

file "/etc/yum.repos.d/mysql-community.repo" do
    action :edit
    path "/etc/yum.repos.d/mysql-community.repo"
    block do |content|
        content.gsub!(/^enabled=1/, "enabled=0")
    end
end

mysql[:packages].each do |pkg|
    execute "yum install -y mysql-community-server --enablerepo=#{mysql[:repo]} --disablerepo=appstream"
end