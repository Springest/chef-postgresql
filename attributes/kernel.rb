include_attribute 'postgres::default'

default['postgres']['kernel']['shmmax'] = nil
default['postgres']['kernel']['page_size'] = nil