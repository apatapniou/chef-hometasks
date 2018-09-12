nginx_nginxinstall 'httpd_site' do
  ip lazy { search(:node, 'role:jboss')[0]["network"]["interfaces"]["enp0s8"]["addresses"].detect{|k,v| v[:family] == "inet" }.first }
  ip_nginx lazy { search(:node, 'role:nginx')[0]["network"]["interfaces"]["enp0s8"]["addresses"].detect{|k,v| v[:family] == "inet" }.first }

  action :create
end
