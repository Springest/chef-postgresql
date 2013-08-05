include_attribute 'postgres::default'

default["postgres"]["replication"]["user"]       = 'replicator'
default["postgres"]["replication"]["password"]   = false
default["postgres"]["wal_level"]                 = 'hot_standby'
default["postgres"]["max_wal_senders"]           = 5
default["postgres"]["wal_keep_segments"]         = 32
