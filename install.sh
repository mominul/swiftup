#! /bin/bash

# swiftup installer

echo "|-------------------------------------------|"
echo "|-----Welcome to the swiftup installer------|"
echo "|-------------------------------------------|"
echo

echo "Installing required packages for your system need by both swiftup and swift toolchains."
echo "You might need to type your password for installation."

sudo apt install tar curl gnupg clang libicu-dev

echo "Done installaton of packages!"

echo "Downloading swiftup"

curl -L https://github.com/mominul/swiftup/releases/download/0.0.1/swiftup.tar.gz | tar xz -C ~

echo "Configuring Environment"
