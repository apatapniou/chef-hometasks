jboss_jbossinstall 'appsite' do
 # ip lazy { search(:node, 'role:jboss')[0]["network"]["interfaces"]["enp0s8"]["addresses"]$
 # ip_nginx lazy { search(:node, 'role:nginx')[0]["network"]["interfaces"]["enp0s8"]["addre$

  action :create
end



