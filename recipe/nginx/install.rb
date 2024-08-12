nginx = node[:nginx]
abort("undefined error: node[:nginx]") if nginx.nil?

repo_path = "/etc/yum.repos.d/nginx.repo"
remote_file repo_path do
   action :create
   source "remote#{repo_path}"
   mode "644"
end

execute "yum-config-manager --enable nginx-mainline" do
   user "root"
end

package "nginx" do
    action :install
    version nginx[:version]
end

service "nginx" do
    action [:start, :enable]
end
