platform_version = node[:general][:platform_version]

package "epel-release" do
    not_if 'rpm -q epel-release'
end

package "http://rpms.famillecollet.com/enterprise/remi-release-#{platform_version}.rpm" do
    not_if "rpm -q remi-release"
end