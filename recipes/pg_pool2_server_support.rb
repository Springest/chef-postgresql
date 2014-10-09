package "postgresql-#{node["postgres"]["version"]}-pgpool2"

template "#{node["postgres"]["cache_path"]}/pgpool-regclass.sql" do
  source "pgpool-regclass.sql.erb"
  owner "postgres"
  action :create
  notifies :run, 'execute[create-pgpool-regclass]', :immediately
end

execute "create-pgpool-regclass" do
  command "psql -f #{node["postgres"]["cache_path"]}/pgpool-regclass.sql template1"
  user "postgres"
end

template "#{node["postgres"]["cache_path"]}/pgpool-recovery.sql" do
  source "pgpool-recovery.sql.erb"
  owner "postgres"
  action :create
  notifies :run, 'execute[create-pgpool-recovery]', :immediately
end

execute "create-pgpool-recovery" do
  command "psql -f #{node["postgres"]["cache_path"]}/pgpool-recovery.sql template1"
  user "postgres"
  action :nothing
end

cookbook_file "#{node["postgres"]["cache_path"]}/insert_lock.sql" do
  owner "postgres"
  action :create
  notifies :run, 'execute[create-pgpool-insert-lock]', :immediately
end

execute "create-pgpool-insert-lock" do
  command "psql -f #{node["postgres"]["cache_path"]}/insert_lock.sql template1"
  user "postgres"
  action :nothing
end
