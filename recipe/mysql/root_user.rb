require 'dotenv'
Dotenv.load

mycnf_path = '/etc/my.cnf'
mysqladmin_path = '/etc/my.cnf.d/mysql-admin.cnf'

execute "set-root-password" do
    command <<-EOL
       tmp_pass=$(grep 'temporary password' /var/log/mysql/mysqld.log | awk -F'root@localhost: ' '{print $2}') &&
       mysql -uroot -p"$tmp_pass" --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '#{ENV["DB_ROOT_PASSWORD"]}';"
    EOL
    not_if "mysql --defaults-file=#{mycnf_path} -uroot -e 'show databases;'"
end

template mysqladmin_path do
    owner "mysql"
    group "mysql"
    mode "0600"
    source "template#{mysqladmin_path}.erb"
    variables(root_password: ENV["DB_ROOT_PASSWORD"])
end

file "/var/log/mysql/mysqld.log" do
    owner "mysql"
    group "mysql"
    mode "0644"
end
