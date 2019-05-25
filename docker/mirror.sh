#!/bin/sh

env

git config --global credential.helper '!aws codecommit credential-helper $@' 
git config --global credential.UseHttpPath true

aws secretsmanager get-secret-value --secret-id $SECRET_NAME | jq -r '.SecretString' > /tmp/key && chmod 400 /tmp/key

GIT_SSH_COMMAND="ssh -i /tmp/key -o StrictHostKeyChecking=no " git clone --mirror $SOURCE_REPO source
cd source && git push --mirror $TARGET_REPO
