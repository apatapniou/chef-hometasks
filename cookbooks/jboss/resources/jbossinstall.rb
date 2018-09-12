action :create do
package 'java-1.8.0-openjdk' do
  action :install
end

user node['jboss']['jboss_user'] do
  shell '/bin/false'
end

group node['jboss']['jboss_group'] do
  action :create
end

package 'unzip' do
  action :install
end

remote_file '/opt/jboss.zip' do
  source node['jboss']['dl_url']
  owner node['jboss']['jboss_user']
  group node['jboss']['jboss_group']
end

bash 'unzip' do
  code <<-EOH
    mkdir -p /opt/jboss 
    unzip /opt/jboss.zip -d /opt 
    cp -r /opt/jboss-5.1.0.GA/* /opt/jboss/ 
    chown -R web:web /opt/jboss
    EOH
  not_if { ::File.exist?("#{node['jboss']['jboss_home']}/server")}
end

systemd_unit 'jboss.service' do 
  content <<-EOU
  [Unit]
  Description=Jboss Application Server
  After=network.target
  [Service]
  Type=forking
  User=web
  Group=web
  ExecStart=/bin/bash -c 'nohup /opt/jboss/bin/run.sh -b 192.168.100.201 &'
  ExecStop=/bin/bash -c 'bin/shutdown.sh -s 192.168.100.201 -u admin -p admin'
  [Install]
  WantedBy=multi-user.target
  EOU
  action [ :create, :enable, :start ]
end

remote_file '/opt/jboss/server/default/deploy/sample.war' do
  source "https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/sample.war"
  owner node['jboss']['jboss_user']
  group node['jboss']['jboss_group']
  show_progress true
  action :create_if_missing
end
end
