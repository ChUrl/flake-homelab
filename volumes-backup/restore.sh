#!/usr/bin/env bash

VOLUME_NAME="wireguard_vps_config"

sudo docker run --rm -v /home/christoph/volumes-backup:/backup -v "$VOLUME_NAME":/data debian:stretch-slim bash -c "cd /data && /bin/tar -xzvf /backup/$VOLUME_NAME.tar.gz"
