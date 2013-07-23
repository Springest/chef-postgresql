#
# Cookbook Name:: postgres
# Recipe:: client
#

include_recipe "postgres"

package "postgresql-client-#{node["postgres"]["version"]}"
