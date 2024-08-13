require './itamae/spec/helper/spec_helper'

version = node[:php][:version]
wp_enable = node[:php][:wordpress]
package_name = node[:php][:package]

version_short = version.split("-")[0]

if wp_enable
    phpfpm_conf  = "/etc/php-fpm.d/www.conf"
    packages = ["#{package_name}-php","#{package_name}-php-fpm","#{package_name}-php-mysqlnd","#{package_name}-php-gd"]

    packages.each do |p|
        describe package(p) do
            it { should be_installed.by('rpm').with_version(version_short) }  if p.tr("-","")
        end
    end

    describe service('php-fpm') do
        it { should be_enabled }
        it { should be_running } 
    end

    describe file(phpfpm_conf) do
        it { should contain "user = nginx" }
        it { should contain "group = nginx" }
        it { should contain "listen = /run/php-fpm/www.sock" }
    end
end