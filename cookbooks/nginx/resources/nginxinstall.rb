property :ip, String, required: true
property :ip_nginx, String, required: true

action :create do
  package 'nginx' do
    action :install
end

index_info =  data_bag_item('index_page', 'first')

service "nginx" do
  action [:enable, :start]
end

template "/usr/share/nginx/html/index.html" do
   source 'index.html.erb'
   variables(
     dbk: index_info
   )
   action :create
end

template "/etc/nginx/conf.d/jboss.conf" do
   source 'jboss_conf.conf.erb'
   variables(
 	ip: new_resource.ip,
	ip_nginx: new_resource.ip_nginx
 )
  action :create
  notifies :reload, "service[nginx]"
end
end
