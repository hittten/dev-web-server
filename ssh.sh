#!/usr/bin/env bash
chmod -f 400 .ssh/*; true
chmod -f 664 .ssh/known_hosts; true
chmod -f 664 .ssh/authorized_keys; true
chmod -f 664 .ssh/config; true
chmod -f 664 .ssh/*.pub; true
