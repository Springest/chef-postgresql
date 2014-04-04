include_recipe "postgres::apt_repository"

package "pgpool2"

include_recipe "postgres::kernel"

template "/etc/pgpool2/pcp.conf" do
  source "pcp.conf.erb"
  action :create
  owner "postgres"
  mode "0640"
end

directory "/var/run/postgresql" do
  mode "0755"
  recursive true
  owner "postgres"
end

directory "/var/log/pgpool" do
  mode "0755"
  owner "postgres"
end

directory "/var/log/pgpool/oiddir" do
  mode "0755"
  owner "postgres"
end

template "/etc/pgpool2/pgpool.conf" do
  source "pgpool.conf.erb"
  owner "postgres"
  action :create
  mode "0644"
  notifies :reload, 'service[pgpool2]'
end

service "pgpool2" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end

node.set["postgres"]["pg_hba_defaults"] = false

template "/etc/pgpool2/pool_hba.conf" do
  source "pg_hba.conf.erb"
  owner  "postgres"
  group  "postgres"
  mode   "0640"
  notifies :reload, "service[pgpool2]"
end
