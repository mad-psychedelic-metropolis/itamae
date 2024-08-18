version = node[:php][:version]
package_name = node[:php][:package]
packages = ["#{package_name}-php","#{package_name}-php-fpm","#{package_name}-php-mysqlnd","#{package_name}-php-gd"]

packages.each do |pkg|
    package pkg do
        version version
        action :install
        options "--enablerepo=remi"
    end
end
