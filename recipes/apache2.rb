node.set['apache']['listen_ports'] = %w(80 443)
base_dir = "#{node['apache']['docroot_dir']}/wifi"

directory base_dir do
  action :create
  recursive true
end

template "#{base_dir}/.htaccess" do
  source 'htaccess.erb'
end

include_recipe 'apache2::default'
include_recipe 'apache2::mod_ssl'
include_recipe 'apache2::mod_rewrite'

web_app 'wifi' do
  server_name 'wifi.rax.mbs3.org'
  docroot base_dir
  cookbook 'apache2'
  allow_override 'all'
end
