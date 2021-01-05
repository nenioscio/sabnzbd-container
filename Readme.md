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

Create and run a container manually
==================

```bash
podman create --restart=always -v /nas/nas-data/sabnzbd/incomplete:/incomplete-downloads:Z -v "/nas/nas-data/sabnzbd/complete:/downloads:Z" -v "/nas/nas-data/sabconfig:/config:Z" -e PUID=1000 -e PGID=1000 -e PYTHONIOENCODING=utf-8 --net=host --name sabnzbd kw-sabnzbd:3.1.1
podman start sabnzbd
```

Remove a container
```bash
podman stop sabnzbd
podman rm sabnzbd
```
