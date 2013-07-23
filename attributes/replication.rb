include_attribute 'postgresql::default'

default["postgresql"]["replication"]["user"]     = 'replicator'
default["postgresql"]["replication"]["password"] = false
default["postgresql"]["wal_level"]               = 'hot_standby'
default["postgresql"]["max_wal_senders"]         = 5
default["postgresql"]["wal_keep_segments"]       = 32