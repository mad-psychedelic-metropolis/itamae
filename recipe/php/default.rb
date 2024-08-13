wp_enable = node[:php][:wordpress]

include_recipe "repo_install.rb"
if wp_enable
    include_recipe "wp_install.rb"
    include_recipe "wp_config.rb"
end