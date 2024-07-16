#!/usr/bin/env bash

cd ~/ansible-service
sudo apt update -y
sudo apt install make -y
make install
ansible --version
cp ansible.cfg.default ansible.cfg
sed -i -e '/become_ask_pass/d' ansible.cfg
sed -i -e 's/<your username>/hevo_deploy/g' ansible.cfg