# Maximum socket connections
default['postgres']['pgpool2']['somaxconn']               = 128
default['postgres']['pgpool2']['num_init_children']       = 50
default['postgres']['pgpool2']['max_pool']                = 4
default['postgres']['pgpool2']['connection_life_time']    = 0
default['postgres']['pgpool2']['client_idle_limit']       = 0
default['postgres']['pgpool2']['log_standby_delay']       = 'none'
