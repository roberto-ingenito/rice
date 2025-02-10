Se non hai creato una partizione apposita, esegui il comando.<br/>
Se invece hai creato una partizione apposita, sostituisci `/swapfile` con il path corretto e ignora la prima riga.

Puoi vedere il path della partizione con il comando `lsblk`
```sh
sudo fallocate -l 16G /swapfile # ignora se hai creato una partizione
sudo chmod 600 /swapfile 
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab > /dev/null
sudo sed -i '/^HOOKS=/s/)/ resume)/' /etc/mkinitcpio.conf
sudo mkinitcpio -P
sudo filefrag -v /swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}' | sudo tee /sys/power/resume_offset > /dev/null
```