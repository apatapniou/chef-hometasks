package "nginx" do
  action :install
end

service "nginx" do
  action [:enable, :start]
end

index_info =  data_bag_item('index_page', 'first')

template '/usr/share/nginx/html/index.html' do 
  source 'index.html.erb'
  action :create
  variables(dbk: index_info)
  notifies :reload, "service[nginx]"
end


template "/etc/nginx/conf.d/jboss.conf'" do   
  source "jboss_conf.conf.erb"
  variables(
    ip: search(:node, 'roles:jboss')[0]["network"]["interfaces"]["enp0s8"]["addresses"].detect{|k,v| v[:family] == "inet" }.first,
    port: node['nginx']['port']
  )
  notifies :reload, "service[nginx]"
end
