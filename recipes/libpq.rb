#
# Cookbook Name:: postgres
# Recipe:: libpq
#

include_recipe "postgres"

package "libpq5"
package "libpq-dev"
