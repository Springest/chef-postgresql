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

# create a user
unless node["postgres"]["cluster"]["slave"]
  pg_user node["postgres"]["replication"]["user"] do
    privileges :superuser => true, :createdb => false, :login => true
    password node["postgres"]["replication"]["password"] if node["postgres"]["replication"]["password"]
    encrypted_password node["postgres"]["replication"]["encrypted_password"] if node["postgres"]["replication"]["encrypted_password"]
  end
end
