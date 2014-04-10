#
# Cookbook Name:: postgres
# Attributes:: default
#
# Author:: Phil Cohen <github@phlippers.net>
#
# Copyright 2012-2013, Phil Cohen
#

default["postgres"]["version"]                         = "9.2"

default["postgres"]["environment_variables"]           = {}
default["postgres"]["pg_ctl_options"]                  = ""
default["postgres"]["pg_hba"]                          = []
default["postgres"]["pg_hba_defaults"]                 = true
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

# previous postgresql versions
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

