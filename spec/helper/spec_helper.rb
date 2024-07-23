require 'yaml'
require 'erb'
require 'serverspec'
require 'highline/import'

host = ENV["TARGET_HOST"]
options = Net::SSH::Config.for(host)
set :request_pty, true
set :backend, :ssh
set :ssh_options, options
set :host, options[:host_name] || host

def node
    yaml = File.read("#{__dir__}/../../hosts/#{ENV["TARGET_HOST"]}.yml")
    return node ||= YAML.respond_to?(:safe_load) ?
    YAML.safe_load(ERB.new(yaml).result, aliases: true, symbolize_names: true) :
    YAML.load(ERB.new(yaml).result, aliases: true, symbolize_names: true)
end