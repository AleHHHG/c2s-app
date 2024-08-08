
# C2S-App

Aplicação principal

## Rodando localmente

Alterar o arquivo de configuração rabbitmq.yml(Enviada juntamente com o teste) e database.yml

Renomear .env_sample para .env

```bash
  mv .env_sample .env
```

Execute as migrações

```bash
  rails db:create
  rails db:migrate
```

Execute a aplicação

```bash
  rails s
```

Em um novo terminar execute os workers

```bash
  rake sneakers:run
```
