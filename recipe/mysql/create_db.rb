mysql = node[:mysql]
databases = node[:mysql][:databases]

databases.each do |db|
    execute "mysql-create-database" do
        command "sudo mysqladmin -u root create #{db}"
        not_if "sudo mysqlshow -u root #{db}"
    end
end
