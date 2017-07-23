node.set['apache']['listen_ports'] = %w(80 443)
node.set['acme']['contact'] = ['mailto:acme@mbs3.org']
node.set['acme']['endpoint'] = 'https://acme-v01.api.letsencrypt.org'
include_recipe 'acme'

site = "wifi.rax.mbs3.org"

# Generate a self-signed if we don't have a cert to prevent bootstrap problems
acme_selfsigned "#{site}" do
  crt     "/etc/apache2/ssl/#{site}.crt"
  key     "/etc/apache2/ssl/#{site}.key"
  chain    "/etc/apache2/ssl/#{site}.pem"
  owner   "root"
  group   "root"
  notifies :restart, "service[apache2]", :immediate
  not_if { ::File.exists?("/etc/apache2/ssl/#{site}.crt") }
end

site_dir = "#{node['apache']['docroot_dir']}/#{site}"
htdocs = "#{site_dir}/htdocs"

directory htdocs do
  action :create
  recursive true
end

node.set['apache']['proxy']['require'] = "all granted"
include_recipe 'apache2::default'
include_recipe 'apache2::mod_ssl'
include_recipe 'apache2::mod_rewrite'
include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_http'
include_recipe 'apache2::mod_proxy_wstunnel'

web_app "wifi" do
  server_name site
  docroot htdocs
  allow_override 'all'
end

# Get and auto-renew the certificate from Let's Encrypt
acme_certificate "#{site}" do
  crt               "/etc/apache2/ssl/#{site}.crt"
  key               "/etc/apache2/ssl/#{site}.key"
  chain             "/etc/apache2/ssl/#{site}.pem"
  wwwroot           htdocs
  notifies :restart, "service[apache2]"
end
