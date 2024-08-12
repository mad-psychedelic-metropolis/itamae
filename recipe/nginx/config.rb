nginx = node[:nginx]
abort("undefined error: node[:nginx]") if nginx.nil?

dest_path = "/etc/nginx/nginx.conf"
config = nginx[:config]

service "nginx" do
    action :nothing
end

template dest_path do
    variables({"config" => config})
    source "./templates#{dest_path}.erb"
    notifies :reload, "service[nginx]"
end

service "nginx" do
    action :reload
end
