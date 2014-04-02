package "pgpool2"

if node['postgres']['pgpool2'] && node['postgres']['pgpool2']['users']
  template "/etc/pgpool2/pcp.conf"
end
