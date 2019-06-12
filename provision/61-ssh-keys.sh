#!/usr/bin/env bash

echo "## Installing SSH keys"

PUBLIC_KEY="/home/$USER/.provision/id_rsa.pub"
PRIVATE_KEY="/home/$USER/.provision/id_rsa"

sudo chown -R "$USER:$USER" "$HOME/.ssh"

if [[ -f "$PUBLIC_KEY" ]]; then
    echo "## Copying public key to $HOME/.ssh/id_rsa.pub"
    sudo cp -f "$PUBLIC_KEY" "$HOME/.ssh/id_rsa.pub"
    PUBLIC_KEY_CONTENT="$(cat $HOME/.ssh/id_rsa.pub)"

    echo "## Apply permissions to public key"
    sudo chmod 400 "$HOME/.ssh/id_rsa.pub"

    if ! grep -qxF "$PUBLIC_KEY_CONTENT" "$HOME/.ssh/authorized_keys"; then
        echo "## Append public key to authorized_keys ($HOME/.ssh/authorized_keys)"
        echo "$PUBLIC_KEY_CONTENT" >> "$HOME/.ssh/authorized_keys"
    else
        echo "## Public key is already present in authorized keys ($HOME/.ssh/authorized_keys)"
    fi

    if ! sudo grep -qxF "$PUBLIC_KEY_CONTENT" "/root/.ssh/authorized_keys"; then
        echo "## Append public key to authorized keys (/root/.ssh/authorized_keys)"
        echo "$PUBLIC_KEY_CONTENT" | sudo tee -a "/root/.ssh/authorized_keys"
    else
        echo "## Public key is already present in authorized keys (/root/.ssh/authorized_keys)"
    fi
fi

if [[ -f "$PRIVATE_KEY" ]]; then
    echo "## Copy private key to $HOME/.ssh/id_rsa"
    sudo cp -f "$PRIVATE_KEY" "$HOME/.ssh/id_rsa"

    echo "## Apply permissions to private key"
    sudo chmod 400 "$HOME/.ssh/id_rsa"
fi

sudo chown "$USER:$USER" -R "$HOME/.ssh"
