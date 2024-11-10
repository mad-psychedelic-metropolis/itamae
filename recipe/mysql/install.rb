packages = node[:mysql][:packages]

execute "mysql80-community-release-el9.noarch.rpm" do
    command "rpm -Uvh https://repo-mysql-community-release-el8.1.noarch.rpm"
    not_if "rpm -qa | grep mysql84-community-release-el8-1"
end

file "/etc/yum.repo.d/mysql-community.repo" do
    action :edit
    path "/etc/yu,.repos.d/mysql-community-repo"
    block do |content|
        content.gsub!(/^enabled=1/, "enabled=0")
    end
end

mysql[:package].each do |pkg|
    package pkg do
        version mysql[:version]
    end
end

directory "/etc/my.cnf.d" do
    path "/etc/my.cnf.d"
    mode "600"
    owner "mysql"
    group "mysql"
end

execute "old-data-dir" do
    command "rm -rf /var/lib/mysql/"
    only_if "test -e /var/lib/mysql"
end

execute "initialize" do
    command "mysqld --initialize --user=mysql"
end

service "mysqld" do
    action [:start, :enable]
end
