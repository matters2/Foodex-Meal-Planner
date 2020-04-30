require 'bcrypt'

def find_user_by_id(id)
    run_sql("SELECT * FROM users WHERE id = #{ id };")[0]
end

def find_user_by_email(email)
    records = run_sql("SELECT * FROM users WHERE email = '#{ email }';")
    if records.count == 0
        return nil
    else
        return records[0]
    end
end

def create_user(email, password)
    password_digest = BCrypt::Password.create(password)
    sql = "INSERT INTO users (email, password_digest) VALUES ('#{email}', '#{password_digest}');"
    run_sql(sql)
end