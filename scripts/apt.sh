#!/bin/bash

source ./chroot.sh

apt_update() {
    croot 'apt update'
}
