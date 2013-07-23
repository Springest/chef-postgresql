#
# Cookbook Name:: postgres
# Recipe:: default
#


# pin default package preferences
cookbook_file "/etc/apt/preferences.d/pgdg.pref" do
  source "pgdg.pref"
end

case node["platform"]
when "ubuntu"
  include_recipe "postgres::apt_repository"
  package "postgresql-common"  # install common files
when "debian"
  include_recipe "postgres::debian_backports"
  include_recipe "postgres::apt_repository"
end
