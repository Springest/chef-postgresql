#
# Cookbook Name:: postgres
# Recipe:: server
#

include_recipe "postgres"

include_recipe "postgres::kernel"

# install the package
package "postgresql-#{node["postgres"]["version"]}"

execute "stop-pg" do
  command "kill `cat /var/lib/postgresql/#{node['postgres']['version']}/main/postmaster.pid`"
  only_if { File.exists?("/var/lib/postgresql/#{node['postgres']['version']}/main/postmaster.pid") }
end

include_recipe "postgres::pg_pool2_server_support"

# setup the data directory
include_recipe "postgres::data_directory"

# add the configuration
include_recipe "postgres::configuration"

# setup users
include_recipe "postgres::pg_user"

# setup databases
include_recipe "postgres::pg_database"

# declare the system service
include_recipe "postgres::service"
