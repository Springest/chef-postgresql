if node['postgres']['kernel']['shmmax']
  shmmax = node['postgres']['kernel']['shmmax']
  shmall = node['postgres']['kernel']['shmmax'] / node['postgres']['kernel']['page_size']

  execute "kernel-resources-shmmax" do
    command "sysctl -w kernel.shmmax=#{shmmax}; sysctl -w kernel.shmall=#{shmmax};"
    not_if { `cat /proc/sys/kernel/shmmax`.chomp.to_i == shmmax }
  end

  execute "kernel-resources-shmall" do
    command "sysctl -w kernel.shmall=#{shmall};"
    not_if { `cat /proc/sys/kernel/shmall`.chomp.to_i == shmall }
  end
end