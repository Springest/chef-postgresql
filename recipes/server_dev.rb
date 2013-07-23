#
# Cookbook Name:: postgres
# Recipe:: server_dev
#

include_recipe "postgres"

# install the package
package "postgresql-server-dev-#{node["postgres"]["version"]}"
