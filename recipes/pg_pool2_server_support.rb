package "postgresql-#{node["postgres"]["version"]}-pgpool2"

template "/var/chef_file_cache/pgpool-recovery.sql"
template "/var/chef_file_cache/pgpool-regclass.sql"
