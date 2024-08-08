
# C2S-App

Aplicação principal

## Rodando localmente

Renomear .env.sample para .env

```bash
  mv .env.sample .env
```

Build o container

```bash
  docker compose build
```

Execute as migrações

```bash
  docker compose run web rake db:create
  docker compose run web rake db:migrate
```

Execute o container

```bash
  docker compose up
```

Execute os teste unitários

```bash
  docker compose run web bash -c "RAILS_ENV=test bundle exec rspec"
```
