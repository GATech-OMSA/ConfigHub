#!/bin/bash
# chmod +x mac-setup.sh to make the script executable.
# sudo ./mac-setup.sh
  
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Install Xcode Command Line Tools
echo "Installing Xcode Command Line Tools..."
xcode-select --install

# Check if Homebrew is installed and install it if it isn't
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Setup Homebrew environment
   echo "Setting up Homebrew environment..."
   echo '# Set PATH, MANPATH, etc., for Homebrew.' >> ~/.zprofile
   echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
   source ~/.zprofile

else
    echo "Homebrew is already installed; updating Homebrew"
    brew upgrade; brew update; brew doctor;
fi


# Assuming the Brewfile is in the home directory, specify the path accordingly
BREWFILE_PATH="~/Documents/Preference Backup/brew-bundle"

# Check if Brewfile exists
if [ ! -f "$BREWFILE_PATH" ]; then
    echo "Brewfile does not exist at $BREWFILE_PATH"
    echo "Please ensure the Brewfile is in the correct location and try again."
    exit 1
fi

# Install packages from Brewfile
echo "Installing packages from Brewfile..."
brew bundle --file="$BREWFILE_PATH"

brew install --cask https://raw.githubusercontent.com/Homebrew/homebrew-cask/6f220274e3a099bf01747c8d6080898610db81a5/Casks/pdf-expert.rb
brew cu pin pdf-expert

# Cleanup
echo "Cleaning up..."
brew cleanup --prune=all; 

echo "Installation complete! All packages have been installed."
