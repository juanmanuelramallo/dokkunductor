# Dokkunductor

Web UI for dokku.

# Deployment

## 1. Network

In the dokku host machine, use the host network mode for the container.

```
dokku docker-options:add dokkunductor run,deploy --network="host"
```

## 2. SSH Key

Dokku commands are sent via ssh.

To run in machine where dokku is hosted (only once):

```bash
dokku storage:ensure-directory dokkunductor-persistent
dokku storage:mount dokkunductor /var/lib/dokku/data/storage/dokkunductor-persistent:/app/persistent
dokku config:set dokkunductor PERSISTENT_PATH=persistent
```

## 3. Plugins

Install [postgres](https://github.com/dokku/dokku-postgres) and [redis](https://github.com/dokku/dokku-redis).

```bash
sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git postgres
sudo dokku plugin:install https://github.com/dokku/dokku-redis.git redis
```

## 4. HTTP Basic authentication

Set the `HTTP_BASIC_AUTH_NAME` and `HTTP_BASIC_AUTH_PASSWORD` to configure basic authentication.

```bash
dokku config:set dokkunductor HTTP_BASIC_AUTH_NAME=??? HTTP_BASIC_AUTH_PASSWORD=???
```

## 5. Redis

Create a redis instance.
```bash
dokku redis:create dokkunductor-redis
```

Fetch and copy the DSN
```bash
dokku redis:info dokkunductor-redis --dsn
# i.e.: redis://:password@dokku-redis-dokkunductor-redis:6379
```

Fetch and copy the internal IP
```
redis:info dokkunductor-rails --internal-ip
# i.e.: 172.17.0.2
```

Finally set the REDIS_URL env var replacing the host with the internal IP:
```
dokku config:set dokkunductor REDIS_URL=redis://:password@internal_ip:6379
# i.e.: dokku config:set dokkunductor REDIS_URL=redis://:password@172.17.0.2:6379
```

# Development

Docker is required before continuing.

Note that application deployments will fail on Apple new chip arch but everything else will work normally.

1. [Deploy dokku locally via Docker](https://dokku.com/docs/getting-started/install/docker/)
2. Copy the .env.sample file to .env
3. Run dokkunductor
```
./bin/dev
```
4. Visit localhost:3000 and follow the SSH keys configuration steps. Commands must be executed within the dokku container.

Access the dokku container via
```bash
docker exec -it dokku bash
```
