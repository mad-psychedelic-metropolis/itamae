require 'dotenv'
Dotenv.load

mysql = node[:mysql]
databases = node[:mysql][:databases]

databases.each do |db|
    execute "mysql-create-database" do
        command "sudo mysqladmin -uroot -p#{ENV["DB_ROOT_PASSWORD"]} create #{db}"
        not_if "sudo mysqlshow -uroot -p#{ENV["DB_ROOT_PASSWORD"]} #{db}"
    end
end
