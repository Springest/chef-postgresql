package "pgpool2"

include_recipe "postgres::kernel"

template "/etc/pgpool2/pcp.conf" do
	source "pcp.conf.erb"
	action :create
	owner "root"
	only_if { node['postgres']['pgpool2'] && node['postgres']['pgpool2']['users'] }
end

template "/etc/pgpool2/pgpool.conf" do
  source "pgpool.conf.erb"
  owner "root"
  action :create
end
