#
# Cookbook Name:: postgres
# Recipe:: service
#


# define the service
service "postgresql" do
  supports :restart => true, :reload => true
  action [:enable, :start]
end
