package_name = node[:php][:package]
packages = ["php","php-fpm","php-mysqlnd","php-gd"]

packages.each do |pkg|
    package pkg do
        action :install
        options "--enablerepo=remi"
    end
end
