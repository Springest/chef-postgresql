include_recipe "postgres::replication"

template "/etc/postgresql/#{node["postgres"]["version"]}/main/recovery.conf" do
  action :create
  owner 'postgres'
  group 'postgres'
end

directory node['postgres']['archive_directory'] do
  action :create
  owner 'postgres'
  group 'postgres'
  recursive true
end
