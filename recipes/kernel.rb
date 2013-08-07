shmmax = node['postgres']['kernel']['shmmax']
node.set['postgres']['kernel']['shmall'] = node['postgres']['kernel']['shmmax'] / node['postgres']['kernel']['page_size']

template "/etc/sysctl.d/30-postgresql-shm.conf" do
  source "postgresql-shm.conf.erb"
  mode '0644'
end
