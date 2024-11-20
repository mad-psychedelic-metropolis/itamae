require 'dotenv'
Dotenv.load

users = node[:mysql][:users]
database = node[:mysql][:database]
sql_path = '/tmp/grants.sql'
passwords = (0...(users.length)).map{|i| ENV["DB_#{i.to_s}_PASSWORD"]}

template sql_path do
    owner "root"
    group "root"
    mode "0600"
    source "templates#{sql_path}.erb"
    variables(users: users, passwords: passwords)
    notifies :run, "execute[mysql-create-user]", :immediately
    notifies :run, "execute[delete-grants_sql]", :immediately
end

execute "mysql-create-user" do
    user "root"
    command "mysql -u root --password='#{ENV["DB_ROOT_PASSWORD"]}' < #{sql_path}"
    action :nothing
end

execute "delete-grants_sql" do
    user "root"
    command "rm /tmp/grants.sql"
    action :nothing
end
