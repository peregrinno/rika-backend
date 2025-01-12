# Rika App - API de Autenticação

API REST desenvolvida com Ruby/Sinatra para autenticação de usuários utilizando JWT token e PostgreSQL.

## Tecnologias Utilizadas

- Ruby
- Sinatra (Framework Web)
- PostgreSQL (Banco de dados)
- JWT (Autenticação)
- BCrypt (Criptografia de senhas)
- ActiveRecord (ORM)

## Pré-requisitos

- Ruby 3.0+
- PostgreSQL
- Bundler

## Configuração do Projeto

1. Clone o repositório

```bash
git clone <url-do-repositorio>
cd rika-app
```

2. Instale as dependências

```bash
bundle install
```

3. Configure as variáveis de ambiente

```bash
cp .env.example .env
```

4. Edite o arquivo `.env` com suas configurações:

```env
# API Configs
API_NAME=Rika App
CORS_URL=http://localhost:3000
TIMEZONE=America/Recife

# Database Configs
DB_ADAPTER=postgresql
DB_HOST=localhost
DB_NAME=rika_db
DB_USERNAME=seu_usuario_postgres
DB_PASSWORD=sua_senha_postgres
DB_PORT=5432

# JWT Config
JWT_SECRET=sua_chave_secreta_jwt
```

5. Crie e configure o banco de dados

```bash
rake db:create
rake db:migrate
```

## Executando a API

Para iniciar o servidor:

```bash
ruby app.rb
```

Por padrão a API estará disponível em `http://localhost:4567`

## Endpoints

### Registro de Usuário

```http
POST /register
Content-Type: application/json

{
    "email": "usuario@email.com",
    "password": "senha123",
    "name": "Nome Completo",
    "phone": "81999999999"
}
```

Resposta de sucesso:

```json
{
  "id": 1,
  "email": "usuario@email.com",
  "name": "Nome Completo",
  "phone": "81999999999"
}
```

### Login

```http
POST /login
Content-Type: application/json

{
    "email": "usuario@email.com",
    "password": "senha123"
}
```

Resposta de sucesso:

```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9..."
}
```

## Autenticação

Para rotas protegidas, inclua o token JWT no header:

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
```

O token tem validade de 1 hora.

## Estrutura do Projeto

```
.
├── app.rb                    # Arquivo principal
├── Gemfile                   # Dependências
├── .env                      # Variáveis de ambiente
├── .env.example             # Exemplo de variáveis de ambiente
├── config/
│   └── database.yml         # Configuração do banco
├── controllers/
│   └── auth_controller.rb   # Controller de autenticação
├── models/
│   └── user.rb             # Modelo de usuário
├── middlewares/
│   └── auth_middleware.rb  # Middleware de autenticação
└── db/
    └── migrate/            # Migrações do banco
```

## Desenvolvimento

### Criando novas migrações

```bash
rake db:create_migration NAME=nome_da_migracao
```

### Revertendo migrações

```bash
rake db:rollback STEP=1
```

## Produção

Antes de colocar em produção:

1. Configure uma chave JWT_SECRET forte
2. Ajuste as configurações de CORS
3. Configure as variáveis de ambiente do banco de dados
4. Use um servidor de produção (ex: Puma)
5. Configure SSL/TLS

## Contribuição

1. Faça um fork do projeto
2. Crie sua branch de feature (`git checkout -b feature/nova-feature`)
3. Commit suas alterações (`git commit -am 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## Licença

Este projeto está sob a licença MIT.

```

```
