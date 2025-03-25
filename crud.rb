require 'sqlite3'

# connecting db
DB = SQLite3::Database.new('users.db')

# create table if not exists

DB.execute <<-SQL
    CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL
    );
SQL


# create user
def create_user(name, email)
    DB.execute('INSERT INTO users (name, email) VALUES (?, ?)', [name, email])
    puts "Usuario #{name} creado con exito."
end


#read user
def read_users
    users = DB.execute('SELECT * FROM users')
    if users.empty?
        puts "No hay usuarios registrados."
    else
        users.each { |user| puts "ID: #{user[0]}, Nombre: #{user[1]}, Email: #{user[2]}" }
    end
end


#update user

def update_user(id, name, email)
    DB.execute('UPDATE users SET name = ?, email = ? WHERE id = ?', [name, email, id])
    puts "Usuario con ID #{id} actualizado"
end


#delete user

def delete_user(id)
    DB.execute('DELETE FROM users WHERE id = ?', [id])
    puts "Usuario con ID #{id} eliminado"
end




def menu
    loop do
        puts "\n--- CRUD usuarios ---"
        puts "1. Crear usuario"
        puts "2. ver usuarios"
        puts "3. Actualizar usuario"
        puts "4. Eliminar usuario"
        puts "5. Salir"

        print "Selecciona una opción: "
        opcion = gets.chomp.to_i

    case opcion
    when 1
      print "Nombre: "
      name = gets.chomp
      print "Email: "
      email = gets.chomp
      create_user(name, email)
    when 2
      read_users
    when 3
      print "ID del usuario a actualizar: "
      id = gets.chomp.to_i
      print "Nuevo Nombre: "
      name = gets.chomp
      print "Nuevo Email: "
      email = gets.chomp
      update_user(id, name, email)
    when 4
      print "ID del usuario a eliminar: "
      id = gets.chomp.to_i
      delete_user(id)
    when 5
      puts "Saliendo..."
      break
    else
      puts "Opción no válida. Intenta de nuevo."
    end
  end
end

menu