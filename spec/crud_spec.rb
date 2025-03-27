require_relative '../crud'
require 'rspec'
require 'sqlite3'
require 'bcrypt'

RSpec.describe 'CRUD Usuarios' do 
    before(:each) do
        @db = SQLite3::Database.new(':memory:')
        @db.results_as_hash = true 

        @db.execute <<-SQL
            CREATE TABLE users (
                id INTEGER PRIMARY KEY,
                name TEXT,
                email TEXT UNIQUE,
                password TEXT
            );
        SQL

        # consultar esta linea
        Object.send(:remove_const, :DB)
        Object.const_set(:DB, @db)
    end

    describe '#login' do
        before do 
            create_user('Eduardo', 'eduardo@prueba.com', 'prueba1234')
        end 

        # consultar estas lineas
        it 'permite el inicio de sesión con credenciales correctas' do 
            user = login('eduardo@prueba.com', 'prueba1234')
            expect(user).not_to be_nil
            expect(user['email']).to eq('eduardo@prueba.com')
        end

        it 'rechaza el inicio de sesión con credenciales incorrectas' do 
            user = login('eduardo@prueba.com', 'incorrecta')
            expect(user).to be_nil 
        end
    end

    describe '#current_user' do
        before do
            create_user('Eduardo', 'eduardo@prueba.com', 'prueba1234')
            login('eduardo@prueba.com', 'prueba1234')
        end

        it 'devuelve el usuario autenticado' do
            expect(current_user).not_to be_nil
            expect(current_user['email']).to eq('eduardo@prueba.com')
        end
    end

    describe '#logout' do
        before do
            create_user('Eduardo', 'eduardo@prueba.com', 'prueba1234')
            login('eduardo@prueba.com', 'prueba1234')
        end

        it 'cierra la sesión del usuario' do
            logout
            expect(current_user).to be_nil
        end
    end
end