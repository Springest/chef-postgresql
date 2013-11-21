define :pg_user, :action => :create do
  case params[:action]
  when :create
    privileges = {
      :superuser => false,
      :createdb => false,
      :login => true
    }
    privileges.merge! params[:privileges] if params[:privileges]

    sql = [params[:name]]

    sql.push privileges.to_a.map! { |p,b| (b ? '' : 'NO') + p.to_s.upcase }.join ' '

    if params[:encrypted_password]
      sql.push "ENCRYPTED PASSWORD '#{params[:encrypted_password]}'"
    elsif params[:password]
      sql.push "PASSWORD '#{params[:password]}'"
    end

    sql = sql.join ' '

    exists = ["psql -c \"SELECT usename FROM pg_user WHERE usename='#{params[:name]}'\""]
    exists.push "| grep #{params[:name]}"
    exists = exists.join ' '

    execute "altering pg user #{params[:name]}" do
      user "postgres"
      command "psql -c \"ALTER ROLE #{sql}\""
      only_if exists, :user => "postgres"
    end

    execute "creating pg user #{params[:name]}" do
      user "postgres"
      command "psql -c \"CREATE ROLE #{sql}\""
      not_if exists, :user => "postgres"
    end

    if params[:grants]
      params[:grants].each do |grant|
        privileges = grant["privileges"].kind_of?(Array) ? grant["privileges"].join(", ") : grant["privileges"]
        grant_type = grant["type"]

        if grant_type == "schema"
          execute("GRANT #{privileges} ON #{grant["schema"]} TO #{params[:name]}") do
            user "postgres"
            command "psql -c 'GRANT #{privileges} ON SCHEMA #{grant["schema"]} TO #{params[:name]}'"
          end
        elsif grant_type == "table"
          if grant["all_tables"] == true
            ruby_block "grant all tables of database #{grant["database"]} to user #{params[:name]}" do
              block do
                cmd = %Q{su postgres -c 'psql -d #{grant["database"]} -t -c "GRANT #{privileges} ON ALL TABLES IN SCHEMA public TO #{params[:name]};"'}
                output = `#{cmd}`
                Chef::Application.fatal!("Grant #{privileges} on all tables failed for user #{params[:name]}") if $?.exitstatus != 0
              end
            end
          else # Not all tables
            grant["tables"].each do |table|
              execute "Granting #{privileges} on table #{table} to #{params[:name]}" do
                user "postgres"
                command %Q{psql -d #{grant["database"]} -t -c "GRANT #{privileges} ON TABLE #{table} TO #{params[:name]};"}
              end
            end
          end
        else
          raise "Unkown type '#{grant["type"]}'"
        end
      end
    end

  when :drop
    execute "dropping pg user #{params[:name]}" do
      user "postgres"
      command "psql -c \"DROP ROLE IF EXISTS #{params[:name]}\""
    end
  end
end
