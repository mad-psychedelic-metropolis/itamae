mysqlserver_path = '/etc/my.cnf'

directory "/etc/my.cnf.d" do
    path "/etc/my.cnf.d"
    mode "600"
    owner "mysql"
    group "mysql"
end

directory "/var/log/mysql" do
    path "/var/log/mysql"
    mode "600"
    owner "mysql"
    group "mysql"
end

execute "old-data-dir" do
    command "rm -rf /var/lib/mysql/"
    only_if "test -e /var/lib/mysql"
end

execute "generate mysql-sock" do
    command "touch /var/lib/mysql/mysql.sock"
end

execute "initialize" do
    command "mysqld --initialize --user=mysql"
end

template mysqlserver_path do
    source "./templates#{mysqlserver_path}.erb"
end

service "mysqld" do
    action [:start, :enable]
end
