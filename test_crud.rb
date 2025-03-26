require 'minitest/autorun'
require_relative 'crud'
require 'sqlite3'

class TestCrud < Minitest::Test
    def setup
        # Crear una base de datos en memoria para pruebas
        @db = SQLite3::Database.new(':memory:')
        @db.results_as_hash = true
        @db.execute <<-SQL
        CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL
        );
        SQL
        # Sobrescribir la base de datos global con la de prueba
        Object.const_set(:DB, @db)
    end

    def test_hash_password
        password = "prueba123"
        hashed = hash_password(password)
        assert BCrypt::Password.new(hashed) == password, "La contraseña no coincide"
    end

    def test_create_user
        create_user("Eduardo", "eduardo@prueba", "prueba123")
        user = DB.execute("SELECT * FROM users WHERE email = ?", ["eduardo@prueba.com"]).first
        refute_nil user, "El usuario no fue creado en la base de datos"
        assert_equal "Eduardo", user["name"]
    end 

    def test_login_success
        create_user("Eduardo", "eduardo@prueba.com", "prueba123")
        login("eduardo@prueba.com", "prueba123")
        assert_equal "Eduardo", $session_user["name"], "El usuario no se autenticó correctamente"
      end
    
      def test_login_failure
        create_user("Eduardo", "eduardo@prueba.com", "prueba123")
        login("eduardo@prueba.com", "incorrecta")
        assert_nil $session_user, "El usuario no debería haber iniciado sesión"
      end

    def teardown
        @db.close
    end

end