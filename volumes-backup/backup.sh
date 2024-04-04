#!/usr/bin/env bash

VOLUME_NAME="wireguard_vps_config"

sudo docker run --rm -v /home/christoph/HomeLab/volumes-backup:/backup -v "$VOLUME_NAME":/data:ro debian:stretch-slim bash -c "cd /data && /bin/tar -czvf /backup/$VOLUME_NAME.tar.gz ."
