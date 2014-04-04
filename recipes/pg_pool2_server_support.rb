package "postgresql-#{node["postgres"]["version"]}-pgpool2"

template "/var/chef_file_cache/pgpool-regclass.sql" do
  source "pgpool-regclass.sql.erb"
  owner "root"
  action :create
  notifies :run, 'execute[create-pgpool-regclass]', :immediately
end

execute "create-pgpool-regclass" do
  command "psql -f /var/chef_file_cache/pgpool-regclass.sql template1"
  user "postgres"
end

template "/var/chef_file_cache/pgpool-recovery.sql" do
  source "pgpool-recovery.sql.erb"
  owner "root"
  action :create
  notifies :run, 'execute[create-pgpool-recovery]', :immediately
end

execute "create-pgpool-recovery" do
  command "psql -f /var/chef_file_cache/pgpool-recovery.sql template1"
  user "postgres"
end

cookbook_file "/var/chef_file_cache/insert_lock.sql" do
  owner "root"
  action :create
  notifies :run, 'execute[create-pgpool-insert-lock]', :immediately
end

execute "create-pgpool-insert-lock" do
  command "psql -f /var/chef_file_cache/insert_lock.sql template1"
  user "postgres"
end
