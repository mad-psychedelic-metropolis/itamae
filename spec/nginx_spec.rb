require './itamae/spec/helper/spec_helper'

version = node[:nginx][:version]
config = node[:nginx][:config]
general = node[:general]

conffile = "/etc/nginx/nginx.conf"
version_short = version.split(":")[1].split("-")[0]

describe package('nginx') do
    it { should be_installed.by('rpm').with_version(version_short) }
end

describe service('nginx') do
    it { should be_enabled }
    it { should be_running } 
end

describe file(conffile) do
    it { should contain "worker_processes #{config[:process]};" }
    it { should contain "worker_connections #{config[:connection]};" }

    it { should contain "listen 80;" }
    if  config[:ssl_enable]
        it { should contain "listen 443 ssl;" }
        it { should contain "listen 80;\nreturn 301 https://$host$request_uri;" }
    end

    if  config[:ssl_enable]
        it { should contain "ssl_certificate /etc/letsencrypt/live/#{domain}/fullchain.pem;" }
        it { should contain "ssl_trusted_certificate /etc/letsencrypt/live/#{domain}/chain.pem;" }
        it { should contain "ssl_certificate_key /etc/letsencrypt/live/#{domain}/privkey.pem;" }
    end

    if  config[:wordpress][:enable]
        it { should contain "root #{general[:public]};" }
    end
end
