require 'securerandom'
require 'cpf_cnpj'
require 'date'

ACCOUNTS = []

def signup(input)
  id = SecureRandom.uuid

  acc = ACCOUNTS.find { |account| account[:email] == input[:email] }

  if acc.nil?
    if params[:name] =~ /[a-zA-Z] [a-zA-Z]+/
      if params[:email] =~ /^(.+)@(.+)$/
        if CPF.valid?(params[:cpf])
          if Date.parse(params[:birthday])
            if Date.parse(params[:birthday]) > years_ago
              if CPF.valid?(params[:responsible_cpf])
                ACCOUNTS << { id: id, name: input[:name], email: input[:email],
                              cpf: input[:cpf], car_plate: input[:carPlate],
                              is_passenger: !!input[:isPassenger], is_driver: !!input[:isDriver] }
                return { person_id: id }
              else
                return -6
              end
            else
              ACCOUNTS << { id: id, name: input[:name], email: input[:email],
                              cpf: input[:cpf], car_plate: input[:carPlate],
                              is_passenger: !!input[:isPassenger], is_driver: !!input[:isDriver] }
              return { person_id: id }
            end
          else
            return -5
          end
        else
          return -4
        end
      else
        return -3
      end
    else
      return -2
    end
  else
    return -1
  end
end

def years_ago(year = 18)
  d = Date.today
  return Date.parse("#{d.year - year}-#{d.month}-#{d.day}")
end
