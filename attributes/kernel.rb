include_attribute 'postgres::default'

default['postgres']['kernel']['shmmax'] = 33554432
default['postgres']['kernel']['page_size'] = 4096