#!/bin/bash

sudo sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 10/' /etc/pacman.conf 
archinstall --conf user_configuration.json --cred user_credentials.json
