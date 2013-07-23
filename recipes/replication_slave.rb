include_recipe "postgres::replication"

template "/etc/postgresql/#{node["postgres"]["version"]}/main/recovery.conf" do
  action :create
  owner 'postgres'
  group 'postgres'
end

directory "/var/lib/postgresql/#{node["postgres"]["version"]}/archive/" do
  action :create
  owner 'postgres'
  group 'postgres'
  recursive true
end
