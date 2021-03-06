#!/bin/sh

$WINE ghc-pkg$GHCVERSION unregister leksah || true
$WINE ghc-pkg$GHCVERSION unregister leksah-server || true
$WINE ghc-pkg$GHCVERSION unregister ltk || true

export FULL_VERSION=`grep '^version: ' leksah.cabal | sed 's|version: ||' | tr -d '\r'`
export SHORT_VERSION=`echo $FULL_VERSION | sed 's|\.[0-9]*\.[0-9]*$||'`
export LEKSAH_X_X_X_X=leksah-$FULL_VERSION
export LEKSAH_X_X=leksah-$SHORT_VERSION

export GHC_VER=`$WINE ghc$GHCVERSION --numeric-version | tr -d '\r'`
export LEKSAH_X_X_X_X_GHC_X_X_X=leksah-$FULL_VERSION-ghc-$GHC_VER

export GTK_PREFIX=`$WINE pkg-config --libs-only-L gtk+-3.0 | sed 's|^-L||' | sed 's|/lib *.*$||'`

echo Staging Leksah in $GTK_PREFIX

# cabal sandbox init || true
# (cd vendor/yi/yi && cabal sandbox init --sandbox=../../../.cabal-sandbox) || true
# (cd vendor/ltk && cabal sandbox init --sandbox=../../.cabal-sandbox) || true
# (cd vendor/leksah-server && cabal sandbox init --sandbox=../../.cabal-sandbox) || true
# cabal sandbox add-source ./vendor/ltk ./vendor/leksah-server ./vendor/yi/yi || true

# These don't like all the extra options we pass (CPPFLAGS and --extra-lib-dirs)
# Gtk2Hs needs the latest Cabal to install properly
# cabal install --with-ghc=ghc$GHCVERSION -j4 text parsec network uniplate Cabal --constraint='text>=0.11.3.1' --constraint='parsec>=3.1.3' --constraint='ghc -any' || true

# Only used by OS X
# export DYLD_LIBRARY_PATH="/System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ImageIO.framework/Versions/A/Resources:$GTK_PREFIX/lib:$DYLD_LIBRARY_PATH"

if test "`uname`" = "Darwin"; then
    cd ./vendor/ltk || exit
    cabal install -j4 --with-ghc=ghc$GHCVERSION || exit
    cd ../leksah-server || exit
    cabal install --enable-tests -j4 --with-ghc=ghc$GHCVERSION || exit
    cabal test || exit
#    cd ../yi || exit
#    cabal install -j4 -fpango --with-ghc=ghc$GHCVERSION || exit
    cd ../.. || exit
    cabal install -j4 -fwebkit -f-yi --with-ghc=ghc$GHCVERSION || exit
else
    $WINE cabal install ./ ./vendor/ltk ./vendor/leksah-server                gtk3 ghcjs-dom jsaddle vendor/haskellVCSWrapper/vcswrapper vendor/haskellVCSGUI/vcsgui --with-ghc=ghc$GHCVERSION -j4 -fwebkit -f-yi -fpango -f-vty --force-reinstalls || exit
#  if [ "$GHC_VER" != "7.0.3" ] && [ "$GHC_VER" != "7.0.4" ] && [ "$GHC_VER" != "7.6.1" ]; then
#    echo https://github.com/yi-editor/yi.git >> sources.txt
#    export LEKSAH_CONFIG_ARGS="$LEKSAH_CONFIG_ARGS -fyi -f-vty -f-dyre -fpango"
#  fi
fi

export SERVER_VERSION=`grep '^version: ' vendor/leksah-server/leksah-server.cabal | sed 's|version: ||' | tr -d '\r'`
export LEKSAH_SERVER_X_X_X_X=leksah-server-$SERVER_VERSION

