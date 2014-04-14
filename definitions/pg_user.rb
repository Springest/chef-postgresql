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
            execute("GRANT #{privileges} ON ALL TABLES IN SCHEMA public TO #{params[:name]} for database #{grant["database"]}") do
              user "postgres"
              command "psql -d #{grant["database"]} -t -c 'GRANT #{privileges} ON ALL TABLES IN SCHEMA public TO #{params[:name]};'"
            end
          else # Not all tables
            grant["tables"].each do |table|
              execute "Granting #{privileges} on table #{table} to #{params[:name]}" do
                user "postgres"
                command %Q{psql -d #{grant["database"]} -t -c "GRANT #{privileges} ON TABLE #{table} TO #{params[:name]};"}
                only_if { %Q{psql -d #{grant["database"]} -t -c "\dt" | grep #{table} | wc -l}.to_i > 0 }
              end
            end
          end
        elsif grant_type == "sequence"
          if grant["all_sequences"] == true
            execute("GRANT #{privileges} ON ALL SEQUENCES IN SCHEMA public TO #{params[:name]}") do
              user "postgres"
              command "psql -d #{grant["database"]} -t -c 'GRANT #{privileges} ON ALL SEQUENCES IN SCHEMA public TO #{params[:name]};'"
            end
          else # Not all sequences
            grant["sequences"].each do |sequence|
              execute "Granting #{privileges} on sequence #{sequence} to #{params[:name]}" do
                user "postgres"
                command %Q{psql -d #{grant["database"]} -t -c "GRANT #{privileges} ON SEQUENCE #{sequence} TO #{params[:name]};"}
                only_if { %Q{psql -d #{grant["database"]} -t -c "\ds" | grep #{sequence} | wc -l}.to_i > 0 }
              end
            end
          end
        elsif grant_type == "default"
          execute("ALTER DEFAULT PRIVILEGES IN SCHEMA #{grant["schema"]} GRANT #{privileges} ON TABLES TO #{params[:name]}") do
            user "postgres"
            command "psql -c 'ALTER DEFAULT PRIVILEGES IN SCHEMA #{grant["schema"]} GRANT #{privileges} ON TABLES TO #{params[:name]}'"
          end
        else
          raise "Unkown type '#{grant["type"]}'"
        end
      end
    end

    if params[:statement_timeout]
      statement_timeout = params[:statement_timeout] > 1000 ? params[:statement_timeout] : "#{params[:statement_timeout]}000"
      execute("ALTER ROLE #{params[:name]} SET statement_timeout = #{params[:statement_timeout]}000") do
        user "postgres"
        command "psql -c 'ALTER ROLE #{params[:name]} SET statement_timeout = #{statement_timeout}'"
      end
    end

  when :drop
    execute "dropping pg user #{params[:name]}" do
      user "postgres"
      command "psql -c \"DROP ROLE IF EXISTS #{params[:name]}\""
    end
  end
end
