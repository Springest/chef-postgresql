# chef-postgres

## Description

Installs [PostgreSQL](http://www.postgresql.org), The world's most advanced open source database.

This installs postgres 9.x from the [PostgreSQL backports for stable Ubuntu releases](https://launchpad.net/~pitti/+archive/postgresql).

Currently supported versions:

* `9.0`
* `9.1`
* `9.2`

The default version is `9.2`.

## Requirements

### Supported Platforms

The following platforms are supported by this cookbook, meaning that the recipes run on these platforms without error:

* Ubuntu
* Debian 6


## Recipes

* `postgres` - Set up the apt repository and install dependent packages
* `postgres::apt_repository` - Internal recipe to setup the apt repository
* `postgres::client` - Front-end programs for PostgreSQL 9.x
* `postgres::configuration` - Internal recipe to manage configuration files
* `postgres::contrib` - Additional facilities for PostgreSQL
* `postgres::data_directory` - Internal recipe to setup the data directory
* `postgres::dbg` - Debug symbols for the server daemon
* `postgres::debian_backports` - Internal recipe to manage debian backports
* `postgres::doc` - Documentation for the PostgreSQL database management system
* `postgres::libpq` - PostgreSQL C client library and header files for libpq5 (PostgreSQL library)
* `postgres::pg_database` - Internal recipe to manage specified databases
* `postgres::pg_user` - Internal recipe to manage specified users
* `postgres::postgis` - Geographic objects support for PostgreSQL 9.x
* `postgres::server` - Object-relational SQL database, version 9.x server
* `postgres::server_dev` - Development files for PostgreSQL server-side programming
* `postgres::service` - Internal recipe to declare the system service


## Usage

This cookbook installs the postgresql components if not present, and pulls updates if they are installed on the system.

This cookbook provides three definitions to create, alter, and delete users as well as create and drop databases, or setup extensions. Usage is as follows:


### Users

```ruby
# create a user
pg_user "myuser" do
  privileges :superuser => false, :createdb => false, :login => true
  password "mypassword"
end

# create a user with an MD5-encrypted password
pg_user "myuser" do
  privileges :superuser => false, :createdb => false, :login => true
  encrypted_password "667ff118ef6d196c96313aeaee7da519"
end

# drop a user
pg_user "myuser" do
  action :drop
end
```

Or add users via attributes:

```json
"postgres": {
  "users": [
    {
      "username": "dickeyxxx",
      "password": "password",
      "superuser": true,
      "createdb": true,
      "login": true
    }
  ]
}
```

### Databases and Extensions

```ruby
# create a database
pg_database "mydb" do
  owner "myuser"
  encoding "utf8"
  template "template0"
  locale "en_US.UTF8"
end

# install extensions to database
pg_database_extensions "mydb" do
  languages "plpgsql"              # install `plpgsql` language - single value may be passed without array
  extensions ["hstore", "dblink"]  # install `hstore` and `dblink` extensions - multiple values in array
  postgis true                     # install `postgis` support
end

# drop dblink extension
pg_database_extensions "mydb" do
  action :drop
  extensions "dblink"
end

# drop a database
pg_database "mydb" do
  action :drop
end
```

Or add the database via attributes:

```json
"postgres": {
  "databases": [
    {
      "name": "my_db",
      "owner": "dickeyxxx",
      "template": "template0",
      "encoding": "utf8",
      "locale": "en_US.UTF8",
      "extensions": "hstore"
    }
  ]
}
```

### Configuration

The `postgresql.conf` configuration may be set one of two ways:

* set individual node attributes to be interpolated into the default template
* create a custom configuration hash to write a custom file

To create a custom configuration, set the `node["postgres"]["conf"]` hash with your custom settings:

```json
"postgres": {
  "conf": {
    "data_directory": "/dev/null",
    // ... all options explicitly set here
  }
}
```

You may also set the contents of `pg_hba.conf` via attributes:

```json
"postgres": {
  "pg_hba": [
    { "type": "local", "db": "all", "user": "postgres",   "addr": "",             "method": "ident" },
    { "type": "local", "db": "all", "user": "all",        "addr": "",             "method": "trust" },
    { "type": "host",  "db": "all", "user": "all",        "addr": "127.0.0.1/32", "method": "trust" },
    { "type": "host",  "db": "all", "user": "all",        "addr": "::1/128",      "method": "trust" },
    { "type": "host",  "db": "all", "user": "postgres",   "addr": "127.0.0.1/32", "method": "trust" },
    { "type": "host",  "db": "all", "user": "username",   "addr": "127.0.0.1/32", "method": "trust" }
  ]
}
```


## Attributes

```ruby
# WARNING: If this version number is changed in your own recipes, the
# FILE LOCATIONS (see below) attributes *must* also be overridden in
# order to re-compute the paths with the correct version number.
default["postgres"]["version"]                         = "9.2"

default["postgres"]["environment_variables"]           = {}
default["postgres"]["pg_ctl_options"]                  = ""
default["postgres"]["pg_hba"]                          = []
default["postgres"]["pg_hba_defaults"]                 = true  # Whether to populate the pg_hba.conf with defaults
default["postgres"]["pg_ident"]                        = []
default["postgres"]["start"]                           = "auto"  # auto, manual, disabled

default["postgres"]["conf"]                            = {}
default["postgres"]["initdb_options"]                  = "--locale=en_US.UTF-8"

#------------------------------------------------------------------------------
# POSTGIS
#------------------------------------------------------------------------------
default["postgis"]["version"]                            = "1.5"

#------------------------------------------------------------------------------
# FILE LOCATIONS
#------------------------------------------------------------------------------
default["postgres"]["data_directory"]                  = "/data/postgresql/#{node["postgres"]["version"]}/main"
default["postgres"]["hba_file"]                        = "/etc/postgresql/#{node["postgres"]["version"]}/main/pg_hba.conf"
default["postgres"]["ident_file"]                      = "/etc/postgresql/#{node["postgres"]["version"]}/main/pg_ident.conf"
default["postgres"]["external_pid_file"]               = "/var/run/postgresql/#{node["postgres"]["version"]}-main.pid"


#------------------------------------------------------------------------------
# CONNECTIONS AND AUTHENTICATION
#------------------------------------------------------------------------------

# connection settings
default["postgres"]["listen_addresses"]                = "localhost"
default["postgres"]["port"]                            = 5432
default["postgres"]["max_connections"]                 = 100
default["postgres"]["superuser_reserved_connections"]  = 3
default["postgres"]["unix_socket_directory"]           = "/var/run/postgresql"
default["postgres"]["unix_socket_group"]               = ""
default["postgres"]["unix_socket_permissions"]         = "0777"
default["postgres"]["bonjour"]                         = "off"
default["postgres"]["bonjour_name"]                    = ""

# security and authentication
default["postgres"]["authentication_timeout"]          = "1min"
default["postgres"]["ssl"]                             = true
default["postgres"]["ssl_ciphers"]                     = "ALL:!ADH:!LOW:!EXP:!MD5:@STRENGTH"
default["postgres"]["ssl_renegotiation_limit"]         = "512MB"
default["postgres"]["ssl_ca_file"]                     = ""
default["postgres"]["ssl_cert_file"]                   = "/etc/ssl/certs/ssl-cert-snakeoil.pem"
default["postgres"]["ssl_crl_file"]                    = ""
default["postgres"]["ssl_key_file"]                    = "/etc/ssl/private/ssl-cert-snakeoil.key"
default["postgres"]["password_encryption"]             = "on"
default["postgres"]["db_user_namespace"]               = "off"

# kerberos and gssapi
default["postgres"]["db_user_namespace"]               = "off"
default["postgres"]["krb_server_keyfile"]              = ""
default["postgres"]["krb_srvname"]                     = "postgres"
default["postgres"]["krb_caseins_users"]               = "off"

# tcp keepalives
default["postgres"]["tcp_keepalives_idle"]             = 0
default["postgres"]["tcp_keepalives_interval"]         = 0
default["postgres"]["tcp_keepalives_count"]            = 0


#------------------------------------------------------------------------------
# RESOURCE USAGE (except WAL)
#------------------------------------------------------------------------------

# memory
default["postgres"]["shared_buffers"]                  = "24MB"
default["postgres"]["temp_buffers"]                    = "8MB"
default["postgres"]["max_prepared_transactions"]       = 0
default["postgres"]["work_mem"]                        = "1MB"
default["postgres"]["maintenance_work_mem"]            = "16MB"
default["postgres"]["max_stack_depth"]                 = "2MB"

# kernel resource usage
default["postgres"]["max_files_per_process"]           = 1000
default["postgres"]["shared_preload_libraries"]        = ""

# cost-based vacuum delay
default["postgres"]["vacuum_cost_delay"]               = "0ms"
default["postgres"]["vacuum_cost_page_hit"]            = 1
default["postgres"]["vacuum_cost_page_miss"]           = 10
default["postgres"]["vacuum_cost_page_dirty"]          = 20
default["postgres"]["vacuum_cost_limit"]               = 200

# background writer
default["postgres"]["bgwriter_delay"]                  = "200ms"
default["postgres"]["bgwriter_lru_maxpages"]           = 100
default["postgres"]["bgwriter_lru_multiplier"]         = 2.0

# asynchronous behavior
default["postgres"]["effective_io_concurrency"]        = 1


#------------------------------------------------------------------------------
# WRITE AHEAD LOG
#------------------------------------------------------------------------------

# settings
default["postgres"]["wal_level"]                       = "minimal"
default["postgres"]["fsync"]                           = "on"
default["postgres"]["synchronous_commit"]              = "on"
default["postgres"]["wal_sync_method"]                 = "fsync"
default["postgres"]["full_page_writes"]                = "on"
default["postgres"]["wal_buffers"]                     = -1
default["postgres"]["wal_writer_delay"]                = "200ms"
default["postgres"]["commit_delay"]                    = 0
default["postgres"]["commit_siblings"]                 = 5

# checkpoints
default["postgres"]["checkpoint_segments"]             = 3
default["postgres"]["checkpoint_timeout"]              = "5min"
default["postgres"]["checkpoint_completion_target"]    = 0.5
default["postgres"]["checkpoint_warning"]              = "30s"

# archiving
default["postgres"]["archive_mode"]                    = "off"
default["postgres"]["archive_command"]                 = ""
default["postgres"]["archive_timeout"]                 = 0


#------------------------------------------------------------------------------
# REPLICATION
#------------------------------------------------------------------------------

# master server
default["postgres"]["max_wal_senders"]                 = 0
default["postgres"]["wal_sender_delay"]                = "1s"
default["postgres"]["wal_keep_segments"]               = 0
default["postgres"]["vacuum_defer_cleanup_age"]        = 0
default["postgres"]["replication_timeout"]             = "60s"
default["postgres"]["synchronous_standby_names"]       = ""

# standby servers
default["postgres"]["hot_standby"]                     = "off"
default["postgres"]["max_standby_archive_delay"]       = "30s"
default["postgres"]["max_standby_streaming_delay"]     = "30s"
default["postgres"]["wal_receiver_status_interval"]    = "10s"
default["postgres"]["hot_standby_feedback"]            = "off"


#------------------------------------------------------------------------------
# QUERY TUNING
#------------------------------------------------------------------------------

# planner method configuration
default["postgres"]["enable_bitmapscan"]               = "on"
default["postgres"]["enable_hashagg"]                  = "on"
default["postgres"]["enable_hashjoin"]                 = "on"
default["postgres"]["enable_indexscan"]                = "on"
default["postgres"]["enable_material"]                 = "on"
default["postgres"]["enable_mergejoin"]                = "on"
default["postgres"]["enable_nestloop"]                 = "on"
default["postgres"]["enable_seqscan"]                  = "on"
default["postgres"]["enable_sort"]                     = "on"
default["postgres"]["enable_tidscan"]                  = "on"

# planner cost constants
default["postgres"]["seq_page_cost"]                   = 1.0
default["postgres"]["random_page_cost"]                = 4.0
default["postgres"]["cpu_tuple_cost"]                  = 0.01
default["postgres"]["cpu_index_tuple_cost"]            = 0.005
default["postgres"]["cpu_operator_cost"]               = 0.0025
default["postgres"]["effective_cache_size"]            = "128MB"

# genetic query optimizer
default["postgres"]["geqo"]                            = "on"
default["postgres"]["geqo_threshold"]                  = 12
default["postgres"]["geqo_effort"]                     = 5
default["postgres"]["geqo_pool_size"]                  = 0
default["postgres"]["geqo_generations"]                = 0
default["postgres"]["geqo_selection_bias"]             = 2.0
default["postgres"]["geqo_seed"]                       = 0.0

# other planner options
default["postgres"]["default_statistics_target"]       = 100
default["postgres"]["constraint_exclusion"]            = "partition"
default["postgres"]["cursor_tuple_fraction"]           = 0.1
default["postgres"]["from_collapse_limit"]             = 8
default["postgres"]["join_collapse_limit"]             = 8


#------------------------------------------------------------------------------
# ERROR REPORTING AND LOGGING
#------------------------------------------------------------------------------

# where to log
default["postgres"]["log_destination"]                 = "stderr"
default["postgres"]["logging_collector"]               = "off"
default["postgres"]["log_directory"]                   = "pg_log"
default["postgres"]["log_filename"]                    = "postgresql-%Y-%m-%d_%H%M%S.log"
default["postgres"]["log_file_mode"]                   = 0600
default["postgres"]["log_truncate_on_rotation"]        = "off"
default["postgres"]["log_rotation_age"]                = "1d"
default["postgres"]["log_rotation_size"]               = "10MB"

# These are relevant when logging to syslog:
default["postgres"]["syslog_facility"]                 = "LOCAL0"
default["postgres"]["syslog_ident"]                    = "postgres"
default["postgres"]["silent_mode"]                     = "off"

# when to log
default["postgres"]["client_min_messages"]             = "notice"
default["postgres"]["log_min_messages"]                = "warning"
default["postgres"]["log_min_error_statement"]         = "error"
default["postgres"]["log_min_duration_statement"]      = -1

# what to log
default["postgres"]["debug_print_parse"]               = "off"
default["postgres"]["debug_print_rewritten"]           = "off"
default["postgres"]["debug_print_plan"]                = "off"
default["postgres"]["debug_pretty_print"]              = "on"
default["postgres"]["log_checkpoints"]                 = "off"
default["postgres"]["log_connections"]                 = "off"
default["postgres"]["log_disconnections"]              = "off"
default["postgres"]["log_duration"]                    = "off"
default["postgres"]["log_error_verbosity"]             = "default"
default["postgres"]["log_hostname"]                    = "off"
default["postgres"]["log_line_prefix"]                 = "%t "
default["postgres"]["log_lock_waits"]                  = "off"
default["postgres"]["log_statement"]                   = "none"
default["postgres"]["log_temp_files"]                  = -1
default["postgres"]["log_timezone"]                    = "(defaults to server environment setting)"


#------------------------------------------------------------------------------
# RUNTIME STATISTICS
#------------------------------------------------------------------------------

# query/index statistics collector
default["postgres"]["track_activities"]                = "on"
default["postgres"]["track_counts"]                    = "on"
default["postgres"]["track_functions"]                 = "none"
default["postgres"]["track_activity_query_size"]       = 1024
default["postgres"]["update_process_title"]            = "on"
default["postgres"]["stats_temp_directory"]            = 'pg_stat_tmp'

# statistics monitoring
default["postgres"]["log_parser_stats"]                = "off"
default["postgres"]["log_planner_stats"]               = "off"
default["postgres"]["log_executor_stats"]              = "off"
default["postgres"]["log_statement_stats"]             = "off"


#------------------------------------------------------------------------------
# AUTOVACUUM PARAMETERS
#------------------------------------------------------------------------------

default["postgres"]["autovacuum"]                      = "on"
default["postgres"]["log_autovacuum_min_duration"]     = -1
default["postgres"]["autovacuum_max_workers"]          = 3
default["postgres"]["autovacuum_naptime"]              = "1min"
default["postgres"]["autovacuum_vacuum_threshold"]     = 50
default["postgres"]["autovacuum_analyze_threshold"]    = 50
default["postgres"]["autovacuum_vacuum_scale_factor"]  = 0.2
default["postgres"]["autovacuum_analyze_scale_factor"] = 0.1
default["postgres"]["autovacuum_freeze_max_age"]       = 200000000
default["postgres"]["autovacuum_vacuum_cost_delay"]    = "20ms"
default["postgres"]["autovacuum_vacuum_cost_limit"]    = -1


#------------------------------------------------------------------------------
# CLIENT CONNECTION DEFAULTS
#------------------------------------------------------------------------------

# statement behavior
default["postgres"]["search_path"]                     = '"$user",public'
default["postgres"]["default_tablespace"]              = ""
default["postgres"]["temp_tablespaces"]                = ""
default["postgres"]["check_function_bodies"]           = "on"
default["postgres"]["default_transaction_isolation"]   = "read committed"
default["postgres"]["default_transaction_read_only"]   = "off"
default["postgres"]["default_transaction_deferrable"]  = "off"
default["postgres"]["session_replication_role"]        = "origin"
default["postgres"]["statement_timeout"]               = 0
default["postgres"]["vacuum_freeze_min_age"]           = 50000000
default["postgres"]["vacuum_freeze_table_age"]         = 150000000
default["postgres"]["bytea_output"]                    = "hex"
default["postgres"]["xmlbinary"]                       = "base64"
default["postgres"]["xmloption"]                       = "content"

# locale and formatting
default["postgres"]["datestyle"]                       = "iso, mdy"
default["postgres"]["intervalstyle"]                   = "postgres"
default["postgres"]["timezone"]                        = "(defaults to server environment setting)"
default["postgres"]["timezone_abbreviations"]          = "Default"
default["postgres"]["extra_float_digits"]              = 0
default["postgres"]["client_encoding"]                 = "sql_ascii"

# These settings are initialized by initdb, but they can be changed.
default["postgres"]["lc_messages"]                     = "en_US.UTF-8"
default["postgres"]["lc_monetary"]                     = "en_US.UTF-8"
default["postgres"]["lc_numeric"]                      = "en_US.UTF-8"
default["postgres"]["lc_time"]                         = "en_US.UTF-8"

# default configuration for text search
default["postgres"]["default_text_search_config"]      = "pg_catalog.english"

# other defaults
default["postgres"]["dynamic_library_path"]            = "$libdir"
default["postgres"]["local_preload_libraries"]         = ""


#------------------------------------------------------------------------------
# LOCK MANAGEMENT
#------------------------------------------------------------------------------

default["postgres"]["deadlock_timeout"]                = "1s"
default["postgres"]["max_locks_per_transaction"]       = 64
default["postgres"]["max_pred_locks_per_transaction"]  = 64


#------------------------------------------------------------------------------
# VERSION/PLATFORM COMPATIBILITY
#------------------------------------------------------------------------------

# previous postgres versions
default["postgres"]["array_nulls"]                     = "on"
default["postgres"]["backslash_quote"]                 = "safe_encoding"
default["postgres"]["default_with_oids"]               = "off"
default["postgres"]["escape_string_warning"]           = "on"
default["postgres"]["lo_compat_privileges"]            = "off"
default["postgres"]["quote_all_identifiers"]           = "off"
default["postgres"]["sql_inheritance"]                 = "on"
default["postgres"]["standard_conforming_strings"]     = "on"
default["postgres"]["synchronize_seqscans"]            = "on"

# other platforms and clients
default["postgres"]["transform_null_equals"]           = "off"


#------------------------------------------------------------------------------
# ERROR HANDLING
#------------------------------------------------------------------------------

default["postgres"]["exit_on_error"]                   = "off"
default["postgres"]["restart_after_crash"]             = "on"


#------------------------------------------------------------------------------
# USERS AND DATABASES
#------------------------------------------------------------------------------

default["postgres"]["users"]                           = []
default["postgres"]["databases"]                       = []


#------------------------------------------------------------------------------
# CUSTOMIZED OPTIONS
#------------------------------------------------------------------------------

default["postgres"]["custom_variable_classes"]         = ""
```


## TODO

* Add support for replication setup
* Add installation and configuration for the following packages:

```
postgresql-{version}-debversion
postgresql-{version}-ip4r
postgresql-{version}-pljava-gcj
postgresql-plperl-{version}
postgresql-{version}-pllua
postgresql-{version}-plproxy
postgresql-plpython-{version}
postgresql-{version}-plr
postgresql-{version}-plsh
postgresql-pltcl-{version}
postgresql-server-dev-{version}
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Contributors

Many thanks go to the following who have contributed to making this cookbook even better:

* **[@flashingpumpkin](https://github.com/flashingpumpkin)**
    * recipe bugfixes
    * add `pg_user` and `pg_database` definitions
* **[@cmer](https://github.com/cmer)**
    * add `encrypted_password` param for `pg_user` definition
* **[@dickeyxxx](https://github.com/dickeyxxx)**
    * speed up recipe loading and execution
    * add support for specifying database locale
    * add support for adding users and databases via attributes
* **[@alno](https://github.com/alno)**
    * add support to install additional languages/extensions/postgis to existing databases
    * add `pg_database_extensions` definition
* **[@ermolaev](https://github.com/ermolaev)**
    * improve platform check for source repo
* **[@escobera](https://github.com/escobera)**
    * fix for missing ssl directives in `postgresql.conf`
* **[@cdoughty77](https://github.com/cdoughty77)**
    * allow finer tuning inside pg_hba.conf file
* **[@NOX73](https://github.com/NOX73)**
    * fix `postgresql.conf` ssl parameter failure on 9.1



## License

**chef-postgresql**

* Freely distributable and licensed under the [MIT license](http://phlipper.mit-license.org/2012-2013/license.html).
* Copyright (c) 2012-2013 Phil Cohen (github@phlippers.net) [![endorse](http://api.coderwall.com/phlipper/endorsecount.png)](http://coderwall.com/phlipper)
* http://phlippers.net/
