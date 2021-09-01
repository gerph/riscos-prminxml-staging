#!/bin/bash
##
# Build the index, obtaining the tools first
#

set -e
set -o pipefail

PRINCE_VERSION=14.2
SYSTEM="$(uname -s)"


scriptdir="$(cd "$(dirname "$0")" && pwd -P)"

package_indexed=false

function update_packages() {
    if $package_indexed ; then
        true
    else
        if [[ "${SYSTEM}" = 'Linux' ]] ; then
            apt-get update
            package_indexed=true
        else
            echo "Cannot update packages list on ${SYSTEM}" >&2
            exit 1
        fi
        true
    fi
}


##
# Install a package from the package manager
function install_package() {
    local pkg="$1"
    local install_pkg="${2:-$1}"
    if ! type -p "$1" >/dev/null 2>&1  ; then
        echo "+++ Obtaining $pkg"
        if [[ "${SYSTEM}" = 'Darwin' ]] ; then
            echo "Need $pkg on Darwin" >&2
            exit 1
        elif [[ "${SYSTEM}" = 'Linux' ]] ; then
            # I'm assuming this is Ubuntu
            update_packages && apt-get install -y "$install_pkg"
        else
            echo "Cannot install $pkg on ${SYSTEM}" >&2
            exit 1
        fi
    fi
}


# Install the packages we need for these installations and for the run of the tools.

install_package wget
install_package perl
install_package git
install_package xsltproc
install_package xmllint libxml2-utils
install_package make



if ! type -p riscos-prminxml >/dev/null 2>&1 ; then
    # riscos-prminxml isn't installed, so let's get a copy.
    if [[ ! -x './prminxml-snapshot' ]] ; then
        echo +++ Obtaining riscos-prminxml
        if [[ ! -f ~/.gitconfig ]] ; then
            git config --local user.email 'nobody@nowhere.com'
            git config --local user.name 'Automated merge'
        fi
        git merge origin/prminxml-snapshot
    fi
    export PATH="${scriptdir}:$PATH"
fi

if ! type -p prince >/dev/null 2>&1 ; then
    # princexml isn't installed, so we need to get a version.
    prince_install="${scriptdir}/prince-install-$PRINCE_VERSION"
    if [[ ! -d "$prince_install" ]] ; then
        echo +++ Obtaining prince
        if [[ "$SYSTEM" = 'Darwin' ]] ; then
            url="https://www.princexml.com/download/prince-$PRINCE_VERSION-macos.zip"
            extract_dir="prince-${PRINCE_VERSION}-macos"
            ext="zip"
        elif [[ "$SYSTEM" = 'Linux' ]] ; then
            if [[ -f /etc/lsb-release ]] ; then
                source /etc/lsb-release
                # I'm assuming this is Ubuntu and that it's amd64.
                url="https://www.princexml.com/download/prince-$PRINCE_VERSION-ubuntu${DISTRIB_RELEASE}-amd64.tar.gz"
                extract_dir="prince-${PRINCE_VERSION}-ubuntu${DISTRIB_RELEASE}-amd64"
                ext="tar.gz"

                # We also seem to need some libraries to be installed (there's no binary so this will just install)
                install_package libtiff5
                install_package libgif7
                install_package libpng16-16
                install_package liblcms2-2
                install_package libcurl4
                install_package libfontconfig1
            else
                echo "Unrecognised Linux version" >&2
                exit 1
            fi
        else
            echo "Unrecognised OS" >&2
            exit 1
        fi

        # Download the prince installation
        archive="/tmp/prince-${PRINCE_VERSION}.${ext}"
        wget -q -O "${archive}" "$url"
        # Now extract it.
        if [[ "${ext}" = 'zip' ]] ; then
            unzip "${archive}"
        else
            tar zxvf "${archive}"
        fi

        # Install it into our temporary directory
        echo | "${extract_dir}/install.sh" "${prince_install}"

        # Clean up
        rm "$archive"
        rm -rf "$extract_dir"
    fi
    export PATH="${prince_install}/bin:$PATH"
fi


echo Environment now set up...
riscos-prminxml --version
prince --version


echo Run the build...
make
