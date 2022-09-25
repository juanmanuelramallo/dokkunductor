# Dokkunductor

Web UI for dokku.

## SSH Key

Dokku commands are sent via ssh.

To run in machine where dokku is hosted (only once):

```bash
dokku storage:ensure-directory dokkunductor-persistent
dokku storage:mount dokkunductor /var/lib/dokku/data/storage/dokkunductor-persistent:/app/persistent
dokku ps:restart dokkunductor
```
