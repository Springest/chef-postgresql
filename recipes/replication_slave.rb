include_recipe "postgresql::replication"

template "/etc/postgresql/#{node["postgresql"]["version"]}/main/recovery.conf" do
  action :create
  owner 'postgres'
  group 'postgres'
end

directory "/var/lib/postgresql/#{node["postgresql"]["version"]}/archive/" do
  action :create
  owner 'postgres'
  group 'postgres'
  recursive true
end
