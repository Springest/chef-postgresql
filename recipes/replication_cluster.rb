template "#{node["postgres"]["data_directory"]}/pgpool_recovery" do
  mode "0755"
  owner "postgres"
end

template "#{node["postgres"]["data_directory"]}/pgpool_recovery2" do
  mode "0755"
  owner "postgres"
end

template "#{node["postgres"]["data_directory"]}/pgpool_remote_start" do
  mode "0755"
  owner "postgres"
end

directory node['postgres']['archive_directory'] do
  action :create
  owner 'postgres'
  group 'postgres'
  recursive true
end
