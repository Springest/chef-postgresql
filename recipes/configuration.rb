#
# Cookbook Name:: postgres
# Recipe:: configuration
#


pg_version = node["postgres"]["version"]

# environment
template "/etc/postgresql/#{pg_version}/main/environment" do
  source "environment.erb"
  owner  "postgres"
  group  "postgres"
  mode   "0644"
  notifies :restart, "service[postgresql]"
end

# pg_ctl
template "/etc/postgresql/#{pg_version}/main/pg_ctl.conf" do
  source "pg_ctl.conf.erb"
  owner  "postgres"
  group  "postgres"
  mode   "0644"
  notifies :restart, "service[postgresql]"
end

# pg_hba
template node["postgres"]["hba_file"] do
  source "pg_hba.conf.erb"
  owner  "postgres"
  group  "postgres"
  mode   "0640"
  notifies :reload, "service[postgresql]"
end

# pg_ident
template node["postgres"]["ident_file"] do
  source "pg_ident.conf.erb"
  owner  "postgres"
  group  "postgres"
  mode   "0640"
  notifies :reload, "service[postgresql]"
end

# postgresql
pg_template_source = node["postgres"]["conf"].any? ? "custom" : "standard"
template "/etc/postgresql/#{pg_version}/main/postgresql.conf" do
  source "postgresql.conf.#{pg_template_source}.erb"
  owner  "postgres"
  group  "postgres"
  mode   "0644"
  variables(:configuration => node["postgres"]["conf"])
  notifies :restart, "service[postgresql]"
end

# start
template "/etc/postgresql/#{pg_version}/main/start.conf" do
  source "start.conf.erb"
  owner  "postgres"
  group  "postgres"
  mode   "0644"
  notifies :restart, "service[postgresql]", :immediately
end
