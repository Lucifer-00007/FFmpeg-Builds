#!/bin/bash

OPENJPEG_REPO="https://github.com/uclouvain/openjpeg.git"
OPENJPEG_COMMIT="cbee7891a0ee664dd83ca09553d2e30da716a883"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerstage() {
    to_df "ADD $SELF /stage.sh"
    to_df "RUN run_stage"
}

ffbuild_dockerbuild() {
    git-mini-clone "$OPENJPEG_REPO" "$OPENJPEG_COMMIT" openjpeg
    cd openjpeg

    mkdir build && cd build

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" -DBUILD_SHARED_LIBS=OFF -DBUILD_PKGCONFIG_FILES=ON -DBUILD_CODEC=OFF -DWITH_ASTYLE=OFF -DBUILD_TESTING=OFF ..
    make -j$(nproc)
    make install

    cd ../..
    rm -rf openjpeg
}

ffbuild_configure() {
    echo --enable-libopenjpeg
}

ffbuild_unconfigure() {
    echo --disable-libopenjpeg
}
