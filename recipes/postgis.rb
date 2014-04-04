#
# Cookbook Name:: postgres
# Recipe:: postgis
#

include_recipe "postgres"

postgis = node["postgres"]["version"] == "9.3" ? "postgresql-9.3-postgis-2.1" : "postgresql-#{node["postgres"]["version"]}-postgis"
package postgis
