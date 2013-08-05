include_attribute 'postgres::replication'

default["postgres"]["replication"]["master"]   = '127.0.0.1'
default["postgres"]["replication"]["slave"]    = '127.0.0.1'
default["postgres"]["archive_mode"]            = 'on'
default["postgres"]["archive_timeout"]         = 3600
