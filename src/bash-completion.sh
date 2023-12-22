#!/bin/bash

    # Config bash-compleiton for root user
    apt-get install bash-completion -y

    echo -e $cyan"\n Add bash-completion in /root/.bashrc \n"$colorOff

    # Check if bash-completion is called from /root/.bashrc
    if ! grep -q 'if [ -f /etc/bash_completion ]' /root/.bashrc; then
            
        # Add lines at the end of file /root/.bashrc
        echo "# bash-completion config" >> /root/.bashrc
        echo "if [ -f /etc/bash_completion ]; then" >> /root/.bashrc
        echo "    . /etc/bash_completion" >> /root/.bashrc
        echo "fi" >> /root/.bashrc

        echo -e $green" The configuration of bash-completion has been completed."$colorOff
    else
        echo -e $yellow" The configuration of bash-completion has been skiped as it was already configured for the root user."$colorOff
    fi