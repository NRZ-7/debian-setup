#!/bin/bash

    apt-get install sudo -y

    # Define sudoers file
    sudoersFile='/etc/sudoers.d/sudoers'

    echo -e $cyan"\n Adding sudo privileges to $userName \n"$colorOff

    # Check if user is in /etc/sudoers
    if ! grep -q ^$userName /etc/sudoers; then
        # Si no se encuentra el usuario en /etc/sudoers comprueba si existe el fichero sudoers en /etc/sudoers.d/
        if [ -f $sudoersFile ]; then
            # Si el fichero existe, comprueba si existe el usuario
            if ! grep -q ^$userName $sudoersFile; then
                # Si el fichero existe, pero no el usuario, añade las líneas de código necesarias
                echo '# Users with sudo privileges' >> $sudoersFile
                echo -e "$userName  ALL=(ALL:ALL) ALL" >> $sudoersFile
                echo -e $green "$userName added to $sudoersFile"$colorOff
            else
                # Si el fichero y el usuario ya existen, salta la instalación
                echo -e $yellow" Skipping: $userName is already present in $sudoersFile"$colorOff
            fi
        else
            # Si no existe el fichero /etc/sudoers.d/sudoers ni ninguna referencia al usuario en los archivos sudoers. Crea el archivo y añade el código necesario
            touch $sudoersFile
            echo "" >> $sudoersFile
            echo "# Users with sudo privileges" >> $sudoersFile
            echo -e "$userName     ALL=(ALL:ALL) ALL" >> $sudoersFile
            echo -e $green" $userName added to $sudoersFile"$colorOff
        fi
    else
        # Encuentra el usuario configurado en /etc/sudoers. Avisa de que és una mala práctica y sugiere configurarlo en el directorio sudoers.d . Redirige el mensaje a STDERR
        echo -e $red" WARNING: $userName is alredy present to /etc/sudoers. This works but is a bad practice and can broke your updates. Instead you can add your user to /etc/sudoers.d/ directory"$colorOff >&2
    fi