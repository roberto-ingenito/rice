# Disabilitare la scheda video AMD
1. Apri un terminale e crea un nuovo file di blacklist:
    ```bash
    sudo nano /etc/modprobe.d/blacklist-amdgpu.conf
    ```

1. Aggiungi le seguenti righe:
    ```
    blacklist amdgpu
    ```

1. Salva il file (`CTRL+X`, `Y`, `Invio`).

1. Rigenera l'initramfs (non sempre necessario, ma consigliato):
    ```bash
    sudo mkinitcpio -P
    ```

1. Riavvia il sistema:
    ```bash
    sudo reboot
    ```

Con questo metodo, il modulo amdgpu non verrà più caricato e la scheda AMD non sarà più utilizzata dal sistema.