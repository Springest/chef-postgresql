name             "postgres"
maintainer       "Phil Cohen"
maintainer_email "github@phlippers.net"
license          "MIT"
description      "Installs PostgreSQL, The world's most advanced open source database."
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))
version          "0.11.1"
depends "apt"

recipe "postgres",                           "Set up the apt repository and install dependent packages"
recipe "postgres::apt_repository",           "Internal recipe to setup the apt repository"
recipe "postgres::client",                   "Front-end programs for PostgreSQL 9.x"
recipe "postgres::configuration",            "Internal recipe to manage configuration files"
recipe "postgres::contrib",                  "Additional facilities for PostgreSQL"
recipe "postgres::data_directory",           "Internal recipe to setup the data directory"
recipe "postgres::dbg",                      "Debug symbols for the server daemon"
recipe "postgres::debian_backports",         "Internal recipe to manage debian backports"
recipe "postgres::doc",                      "Documentation for the PostgreSQL database management system"
recipe "postgres::libpq",                    "PostgreSQL C client library and header files for libpq5 (PostgreSQL library)"
recipe "postgres::pg_database",              "Internal recipe to manage specified databases"
recipe "postgres::pg_pool2",                 "Pg_pool-II server recipe"
recipe "postgres::pg_pool2_server_support",  "Pg_pool-II client support for the pg servers"
recipe "postgres::pg_user",                  "Internal recipe to manage specified users"
recipe "postgres::postgis",                  "Geographic objects support for PostgreSQL 9.x"
recipe "postgres::server",                   "Object-relational SQL database, version 9.x server"
recipe "postgres::server_dev",               "Development files for PostgreSQL server-side programming"
recipe "postgres::service",                  "Internal recipe to declare the system service"
recipe "postgres::replication",              "Internal recipe for replication base."
recipe "postgres::replication_master",       "Configures master node when replication is enabled."
recipe "postgres::replication_slave",        "Configures slave node(s) when replication is enabled."

%w[ubuntu debian].each do |os|
  supports os
end
