Build Image as latest
=====================

```bash
podman build -t kw-sabnzbd:latest .
# docker build -t kw-sabnzbd:latest .
```

Build Image with Version
========================

```bash
podman build -t kw-sabnzbd:3.1.1 .
# docker build -t kw-sabnzbd:3.1.1 .
```

Run image manually
==================

```bash
podman create --restart=always -v /nas/nas-data/sabnzbd/incomplete:/incomplete-downloads:Z -v "/nas/nas-data/sabnzbd/complete:/downloads:Z" -v "/nas/nas-data/sabconfig:/config:Z" -e PUID=1000 -e PGID=1000 -e PYTHONIOENCODING=utf-8 --net=host --name sabnzbd kw-sabnzbd
podman start sabnzbd
```
