#
# Cookbook Name:: postgres
# Recipe:: server
#

include_recipe "postgres"

# install the package
package "postgresql-#{node["postgres"]["version"]}"

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
