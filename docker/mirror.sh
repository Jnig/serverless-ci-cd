#!/bin/sh

echo "$SSH_KEY" > /tmp/key && chmod 400 /tmp/key 

GIT_SSH_COMMAND="ssh -i /tmp/key" git clone --mirror $source
git push --mirror $target
