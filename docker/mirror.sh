#!/bin/sh

git config --global credential.helper '!aws codecommit credential-helper $@' 
git config --global credential.UseHttpPath true

aws secretsmanager get-secret-value --secret-id $secret_name | jq -r '.SecretString' > /tmp/key && chmod 400 /tmp/key

GIT_SSH_COMMAND="ssh -i /tmp/key -o StrictHostKeyChecking=no " git clone --mirror $source source
cd source && git push --mirror $target
