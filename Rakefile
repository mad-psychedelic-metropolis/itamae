require 'rake'
require 'rspec/core/rake_task'
require 'yaml'
require 'erb'

# Load template.yml.
def load_yml(path)
  begin path
    yaml = File.read("#{__dir__}/hosts/#{path}.yml")
    config = YAML.respond_to?(:safe_load) ?
      YAML.safe_load(ERB.new(yaml).result, aliases: true) :
      YAML.load(ERB.new(yaml).result, aliases: true) || {}
    return config
  rescue
    puts "YML for the target host does not exist."
  end
end

# Get All hosts.
def hosts
  @hosts = []
  Dir.foreach("hosts") { |host| @hosts.push(host.sub(".yml","")) if host.include?(".yml") && !host.include?("template") }
  return @hosts
end

# Recipe
namespace :recipe do
  log_level = ENV["LOG_LEVEL"] || "info"
  hosts.each do |host|

    # Dry-run to install all packages.
    dryrun_task_all = "#{host}:dry-run"
    desc "Run itamae dry-run to [#{host}] for all packages."
    task dryrun_task_all do
      sh "bundle exec itamae ssh -h #{host} -y './hosts/#{host}.yml' --log-level=#{log_level}  --dry-run"
    end

    # Run to install all packages.
    run_task_all = "#{host}:run"
    desc "Run itamae run to [#{host}] for all packages."
    task run_task_all do
      sh "bundle exec itamae ssh -h #{host} -y './hosts/#{host}.yml' --log-level=#{log_level}"
    end

    # Dry-run to install individual package.
    dryrun_task_individual = "#{host}:recipe:dry-run"
    desc "Run itamae dry-run to [#{host}] for an indicidual package."
    task dryrun_task_individual, ["recipe", "option"] do | task, args |
      sh "bundle exec itamae ssh -h #{host} -y './hosts/#{host}.yml' --log-level=#{log_level} ./itamae/recipe/#{args[:recipe]}/#{args[:option]}.rb --dry-run"
    end

    # Run to install individual package.
    run_task_individual = "#{host}:recipe:run"
    desc "Run itamae run to [#{host}] for an indicidual package."
    task run_task_individual, ["recipe", "option"] do | task, args |
      sh "bundle exec itamae ssh -h #{host} -y './hosts/#{host}.yml' --log-level=#{log_level} ./itamae/recipe/#{args[:recipe]}/#{args[:option]}.rb"
    end

  end
end

# Spec
namespace :spec do
  hosts.each do |host|

    RSpec::Core::RakeTask.new(host) do |task|
      ENV["TARGET_HOST"] = host
      task.pattern = "./itamae/spec/unit/*_spec.rb"
    end

    # Run serverspec to test for all packages.
    test_task_all = "target"
    desc "Run serverspec tests to [#{host}] for all packages."
    load_yml(host).keys do |key|
      task spec_target_all do |task|
        ENV["TARGET_HOST"] = host
        sh "rspec ./itamae/spec/#{key}_spec.rb"
      end
    end

    # Run serverspec to test for an individual package.
    spec_target_individual = "#{host}:target"
    desc "Run serverspec run to [#{host}] for an indicidual package."
    task spec_target_individual, ["spec"] do |task, args|
      ENV["TARGET_HOST"] = host
      sh "rspec ./itamae/spec/#{args[:spec]}_spec.rb"
    end
    
  end
end
