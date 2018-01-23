#!/bin/bash

echo "## Installing SSH keys"

PUBLIC_KEY="/home/$USER/.provision/id_rsa.pub"
PRIVATE_KEY="/home/$USER/.provision/id_rsa"

sudo chown -R $USER:$USER "$HOME/.ssh"

if [ -f "$PUBLIC_KEY" ]; then
    echo "## Copying public key to $HOME/.ssh/id_rsa.pub"
    sudo cp -f "$PUBLIC_KEY" "$HOME/.ssh/id_rsa.pub"
    PUBLIC_KEY_CONTENT="$(cat $HOME/.ssh/id_rsa.pub)"

    echo "## Apply permissions to public key"
    sudo chmod 400 "$HOME/.ssh/id_rsa.pub"

    cat $HOME/.ssh/authorized_keys | grep "$PUBLIC_KEY_CONTENT"
    PUB_KEY_APPENDED=$?
    if [ "$PUB_KEY_APPENDED" != "0" ]; then
        echo "## Append public key in authorized_keys"
        sudo cat "$HOME/.ssh/id_rsa.pub" >> "$HOME/.ssh/authorized_keys"
    fi
fi

if [ -f "$PRIVATE_KEY" ]; then
    echo "## Copy private key to $HOME/.ssh/id_rsa"
    sudo cp -f "$PRIVATE_KEY" "$HOME/.ssh/id_rsa"

    echo "## Apply permissions to private key"
    sudo chmod 400 "$HOME/.ssh/id_rsa"
fi

sudo chown $USER:$USER -R "$HOME/.ssh"
