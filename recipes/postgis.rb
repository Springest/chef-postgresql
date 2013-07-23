#
# Cookbook Name:: postgres
# Recipe:: postgis
#

include_recipe "postgres"

package "postgresql-#{node["postgres"]["version"]}-postgis"
