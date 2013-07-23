#
# Cookbook Name:: postgres
# Recipe:: dbg
#

include_recipe "postgres"

package "postgresql-#{node["postgres"]["version"]}-dbg"
