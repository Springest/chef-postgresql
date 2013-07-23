node.set["postgres"]['archive_command'] = "rsync -aq %p postgres@#{node["postgres"]['replication']['slave']}:/var/lib/postgresql/9.2/archive/%f"

include_recipe "postgres::replication"

execute "Recreate cluster" do
  command "pg_dropcluster --stop #{node["postgres"]["version"]} main"
  command "pg_createcluster #{node["postgres"]["initdb_options"]} --start #{node["postgres"]["version"]} -d /var/lib/postgresql/#{node["postgres"]["version"]}/main main"
  notifies :restart, "service[postgresql]"
  not_if exists, :user => default["postgres"]["replication"]["user"]
end

# create a user
pg_user default["postgres"]["replication"]["user"] do
  privileges :superuser => true, :createdb => false, :login => true
  password default["postgres"]["replication"]["password"] if default["postgres"]["replication"]["password"]
  encrypted_password default["postgres"]["replication"]["encrypted_password"] if default["postgres"]["replication"]["encrypted_password"]
end
