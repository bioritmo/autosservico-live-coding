require 'pg'
require 'securerandom'
require 'cpf_cnpj'
require 'date'

def signup(params)
  connection = PG.connect(dbname: 'app', user: 'postgres', password: '123456', host: 'db')

  begin
    id = SecureRandom.uuid

    result = connection.exec_params("SELECT * FROM people WHERE email = $1", [params[:email]])
    acc = result.ntuples.zero? ? nil : result[0]

    if acc.nil?
      if params[:name] =~ /[a-zA-Z] [a-zA-Z]+/
        if params[:email] =~ /^(.+)@(.+)$/
          if CPF.valid?(params[:cpf])
            if Date.parse(params[:birthday])
              if Date.parse(params[:birthday]) > years_ago
                if CPF.valid?(params[:responsible_cpf])
                  connection.exec_params("INSERT INTO people (id, name, email, cpf, birthday, responsible_name, responsible_cpf) VALUES ($1, $2, $3, $4, $5, $6, $7)",
                                        [id, params[:name], params[:email], params[:cpf], params[:birthday], params[:responsible_name], params[:responsible_cpf]])
                  return { person_id: id }
                else
                  # Responsible CPF invalid
                  return -6
                end
              else
                connection.exec_params("INSERT INTO people (id, name, email, cpf, birthday, responsible_name, responsible_cpf) VALUES ($1, $2, $3, $4, $5, $6, $7)",
                                        [id, params[:name], params[:email], params[:cpf], params[:birthday], params[:responsible_name], params[:responsible_cpf]])
                return { person_id: id }
              end
            else
              # Birthday invalid
              return -5
            end
          else
            # CPF invalid
            return -4
          end
        else
          # email invalid
          return -3
        end
      else
        # name invalid
        return -2
      end
    else
      # already exists
      return -1
    end
  rescue Date::Error => e
    return -5
  ensure
    connection.close if connection
  end
end

def years_ago(year = 18)
  d = Date.today
  return Date.parse("#{d.year - year}-#{d.month}-#{d.day}")
end
