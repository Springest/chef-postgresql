node.set["postgres"]['archive_command'] = "rsync -aq %p postgres@#{node["postgres"]['replication']['slave']}:/var/lib/postgresql/9.2/archive/%f"

include_recipe "postgres::replication"

execute "Recreate cluster" do
  command "pg_dropcluster --stop #{node["postgres"]["version"]} main && pg_createcluster #{node["postgres"]["initdb_options"]} --start #{node["postgres"]["version"]} -d /var/lib/postgresql/#{node["postgres"]["version"]}/main main && touch /etc/postgresql/postgres_cluster_recreated"
  notifies :restart, "service[postgresql]"
  not_if { File.exists?('/etc/postgresql/postgres_cluster_recreated') }
end

# create a user
pg_user node["postgres"]["replication"]["user"] do
  privileges :superuser => true, :createdb => false, :login => true
  password node["postgres"]["replication"]["password"] if node["postgres"]["replication"]["password"]
  encrypted_password node["postgres"]["replication"]["encrypted_password"] if node["postgres"]["replication"]["encrypted_password"]
end
