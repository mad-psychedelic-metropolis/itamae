phpfpm_conf = "/etc/php-fpm.d/www.conf"

file phpfpm_conf  do
    action :edit
    block do |content|
        content.gsub!(/^user = apache$/, "user = nginx")
        content.gsub!(/^group = apache$/, "group = nginx")
        content.gsub!(/^listen = 127.0.0.1:9000$/, "listen = /run/php-fpm/www.sock" ) # Align with nginx.conf
    end
    only_if "test -f #{phpfpm_conf}"
end

service "php-fpm" do
    action [:start, :enable]
end