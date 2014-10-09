include_recipe "postgres::apt_repository"

package "pgpool2"

include_recipe "postgres::kernel"

template "/etc/pgpool2/pcp.conf" do
  source "pcp.conf.erb"
  action :create
  owner "postgres"
  mode "0640"
end

template "/etc/pgpool2/pool_passwd" do
  source 'empty'
  action :create_if_missing
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
  notifies :restart, 'service[pgpool2]'
end

service "pgpool2" do
  supports :restart => true
  action [:enable, :start]
end

node.set["postgres"]["pg_hba_defaults"] = false

execute "set socket max connections" do
  command "sysctl -w net.core.somaxconn=#{node['postgres']['pgpool2']['somaxconn']} &&\
    echo 'net.core.somaxconn = #{node['postgres']['pgpool2']['somaxconn']}' > /etc/sysctl"
  only_if { `sysctl net.core.somaxconn | grep #{node['postgres']['pgpool2']['somaxconn']}`.chomp.empty? }
end

template "/etc/pgpool2/pool_hba.conf" do
  source "pg_hba.conf.erb"
  owner  "postgres"
  group  "postgres"
  mode   "0640"
  notifies :reload, "service[pgpool2]"
end

template "/usr/sbin/pgpool_remote_start" do
  owner "postgres"
  group "postgres"
  mode "0755"
end
