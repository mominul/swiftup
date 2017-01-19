#! /bin/bash

# swiftup installer

setupShell() {
  if [ -f "${HOME}/.bash_profile" ]; then
    echo 'export SWIFTUP_ROOT="$HOME/.swiftup"' >> ~/.bash_profile
    echo 'export PATH="$SWIFTUP_ROOT/bin:$PATH"' >> ~/.bash_profile
    echo 'export PATH="$SWIFTUP_ROOT/shims:$PATH"' >> ~/.bash_profile
  elif [ -f "${HOME}/.bashrc" ]; then
    echo 'export SWIFTUP_ROOT="$HOME/.swiftup"' >> ~/.bashrc
    echo 'export PATH="$SWIFTUP_ROOT/bin:$PATH"' >> ~/.bashrc
    echo 'export PATH="$SWIFTUP_ROOT/shims:$PATH"' >> ~/.bashrc
  elif [ -f "${HOME}/.zshrc" ]; then
    echo 'export SWIFTUP_ROOT="$HOME/.swiftup"' >> ~/.zshrc
    echo 'export PATH="$SWIFTUP_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'export PATH="$SWIFTUP_ROOT/shims:$PATH"' >> ~/.zshrc
  else
    echo "Failed to configure environment"
  fi
}

echo "|-------------------------------------------|"
echo "|-----Welcome to the swiftup installer------|"
echo "|-------------------------------------------|"
echo

echo "Installing required packages for your system need by both swiftup and swift toolchains."
echo "You might need to type your password for installation."

sudo apt install tar curl gnupg clang libicu-dev

echo "Done installaton of packages!"

echo "Downloading swiftup"

curl -L https://github.com/mominul/swiftup/releases/download/0.0.2/swiftup.tar.gz | tar xz -C ~

echo "Configuring Environment"

setupShell()

if [[ -f "${HOME}/.swiftup/bin/swiftup" ]]; then
  echo "Successfully installed swiftup"
  ~/.swiftup/bin/swiftup version
fi
