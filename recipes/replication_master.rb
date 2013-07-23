node.set['postgresql']['archive_command'] = "rsync -aq %p postgres@#{node['postgresql']['replication']['slave']}:/var/lib/postgresql/9.2/archive/%f"

include_recipe "postgresql::replication"

execute "Recreate cluster" do
  command "pg_dropcluster --stop #{node["postgresql"]["version"]} main"
  command "pg_createcluster #{node["postgresql"]["initdb_options"]} --start #{node["postgresql"]["version"]} -d /var/lib/postgresql/#{node["postgresql"]["version"]}/main main"
  notifies :restart, "service[postgresql]"
  not_if exists, :user => default["postgresql"]["replication"]["user"]
end

# create a user
pg_user default["postgresql"]["replication"]["user"] do
  privileges :superuser => true, :createdb => false, :login => true
  password default["postgresql"]["replication"]["password"] if default["postgresql"]["replication"]["password"]
  encrypted_password default["postgresql"]["replication"]["encrypted_password"] if default["postgresql"]["replication"]["encrypted_password"]
end
