#
# Cookbook Name:: postgres
# Recipe:: doc
#

include_recipe "postgres"

package "postgresql-doc-#{node["postgres"]["version"]}"
