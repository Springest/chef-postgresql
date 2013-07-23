#
# Cookbook Name:: postgres
# Recipe:: data_directory
#


# ensure data directory exists
directory node["postgres"]["data_directory"] do
  owner  "postgres"
  group  "postgres"
  mode   "0700"
  not_if "test -f #{node["postgres"]["data_directory"]}/PG_VERSION"
end

# initialize the data directory if necessary
bash "postgresql initdb" do
  user "postgres"
  code <<-EOC
  /usr/lib/postgresql/#{node["postgres"]["version"]}/bin/initdb \
    #{node["postgres"]["initdb_options"]} \
    -U postgres \
    -D #{node["postgres"]["data_directory"]}
  EOC
  creates "#{node["postgres"]["data_directory"]}/PG_VERSION"
end
