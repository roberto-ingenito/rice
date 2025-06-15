Dare il comando `ubuntu-drivers devices`, la versione *recommended* sarà quella da installare.

Disinstalla i driver open-source
```sh
sudo apt purge xserver-xorg-video-nouveau
```

Inserisci la versione raccomandata
```sh
sudo apt update && sudo apt upgrade -y
sudo apt install nvidia-driver-<VERSIONE>
```
