#
# Cookbook Name:: postgres
# Recipe:: contrib
#

include_recipe "postgres"

package "postgresql-contrib-#{node["postgres"]["version"]}"
