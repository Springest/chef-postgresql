package "pgpool2"

include_recipe "postgres::kernel"

template "/etc/pgpool2/pcp.conf" do
  source "pcp.conf.erb"
  action :create
  owner "root"
  only_if { node['postgres']['pgpool2'] && node['postgres']['pgpool2']['users'] }
end

directory "/var/run/postgresql" do
  mode 0755
  recursive true
  owner "postgres"
end

template "/etc/pgpool2/pgpool.conf" do
  source "pgpool.conf.erb"
  owner "root"
  action :create
  notifies :reload, 'service[pgpool2]'
end

service "pgpool2" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end
