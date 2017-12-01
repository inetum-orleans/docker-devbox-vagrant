#!/bin/bash

echo "## Managing SSH keys"
PUBLIC_KEY="/home/ubuntu/.provision/id_rsa.pub"
PRIVATE_KEY="/home/ubuntu/.provision/id_rsa"
if [ -f "$PUBLIC_KEY" ]
then
    echo "## Copying public key"
    sudo cp -f $PUBLIC_KEY $HOME/.ssh/
    PUBLIC_KEY_CONTENT="$(cat $HOME/.ssh/id_rsa.pub)"
#    echo $PUBLIC_KEY_CONTENT
    cat $HOME/.ssh/authorized_keys | grep "$PUBLIC_KEY_CONTENT"
    PUB_KEY_APPENDED=$?
    if [ "$PUB_KEY_APPENDED" != "0" ]; then
        echo "## Append public key in authorized_keys"
        sudo cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
    fi

    sudo chown ubuntu:ubuntu $HOME/.ssh/
    echo "## Chmod 400 on public key"
    sudo chmod 400 $HOME/.ssh/id_rsa.pub
fi
if [ -f "$PRIVATE_KEY" ]
then
    echo "## Copying private key"
    sudo cp -f $PRIVATE_KEY $HOME/.ssh/
    sudo chown ubuntu:ubuntu $HOME/.ssh/
    echo "## Chmod 400 suron private key"
    sudo chmod 400 $HOME/.ssh/id_rsa
fi

