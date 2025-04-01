hostname = node[:hostname][:name]
abort("undefined error: node[:hostname][:name]") if hostname.nil?

file '/etc/hostname' do
  content "#{hostname}\n"
  action :create
end
