package "postgresql-#{node["postgres"]["version"]}-pgpool2"

template "/var/chef_file_cache/pgpool-regclass.sql" do
  source "pgpool-regclass.sql.erb"
  owner "root"
  action :create
end

template "/var/chef_file_cache/pgpool-recovery.sql" do
  source "pgpool-recovery.sql.erb"
  owner "root"
  action :create
end
