# Dokkunductor

Web UI for dokku.

# Deployment

## 1. Network

In the dokku host machine, use the host network mode for the container.

```
dokku docker-options:add dokkunductor run,deploy --net="host"
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

Install [postgres](https://github.com/dokku/dokku-postgres).

```bash
sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git postgres
```
