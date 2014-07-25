#
# Cookbook Name:: postgres
# Recipe:: server
#

include_recipe "postgres"

include_recipe "postgres::kernel"

# install the package
package "postgresql-#{node["postgres"]["version"]}"

execute "stop-pg" do
  command "kill `cat /var/lib/postgresql/#{node['postgres']['version']}/main/postmaster.pid`; true"
  only_if { File.exists?("/var/lib/postgresql/#{node['postgres']['version']}/main/postmaster.pid") }
end

# setup the data directory
include_recipe "postgres::data_directory"

# add the configuration
include_recipe "postgres::configuration"

# declare the system service
include_recipe "postgres::service"

# create pgpool-ii support functions
include_recipe "postgres::pg_pool2_server_support"

# setup users
include_recipe "postgres::pg_user" unless node["postgres"]["cluster"]["slave"]

# setup databases
include_recipe "postgres::pg_database"

