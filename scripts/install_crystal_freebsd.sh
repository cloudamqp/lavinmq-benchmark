#!/bin/sh -xe

# Update package repository
pkg update -q

# Install Crystal from FreeBSD packages
pkg install -y crystal
