#!/bin/bash

SCRIPT_REPO="https://github.com/google/shaderc.git"
SCRIPT_COMMIT="e31c4c2e41544d63d90be28c46e4a4793a624240"

ffbuild_enabled() {
    [[ $ADDINS_STR == *4.4* ]] && return -1
    return 0
}

ffbuild_dockerdl() {
    default_dl "$SELF"
    to_df "RUN cd \"$SELF\" && ./utils/git-sync-deps"
}

ffbuild_dockerbuild() {
    cd "$FFBUILD_DLDIR/$SELF"

    mkdir build && cd build

    cmake -GNinja -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" \
        -DSHADERC_SKIP_TESTS=ON -DSHADERC_SKIP_EXAMPLES=ON -DSHADERC_SKIP_COPYRIGHT_CHECK=ON \
        -DENABLE_EXCEPTIONS=ON -DENABLE_CTEST=OFF -DENABLE_GLSLANG_BINARIES=OFF -DSPIRV_SKIP_EXECUTABLES=ON \
        -DSPIRV_TOOLS_BUILD_STATIC=ON -DBUILD_SHARED_LIBS=OFF ..
    ninja -j$(nproc)
    ninja install

    # for some reason, this does not get installed...
    cp libshaderc_util/libshaderc_util.a "$FFBUILD_PREFIX"/lib

    unset CPP_LIB
    if [[ $TARGET == macos* ]]; then
        CPP_LIB="c++"
    else
        CPP_LIB="stdc++"
    fi

    echo "Libs: -l$CPP_LIB" >> "$FFBUILD_PREFIX"/lib/pkgconfig/shaderc_combined.pc
    echo "Libs: -l$CPP_LIB" >> "$FFBUILD_PREFIX"/lib/pkgconfig/shaderc_static.pc

    cp "$FFBUILD_PREFIX"/lib/pkgconfig/{shaderc_combined,shaderc}.pc

    if [[ $TARGET == win* ]]; then
        rm -r "$FFBUILD_PREFIX"/bin "$FFBUILD_PREFIX"/lib/*.dll.a
    elif [[ $TARGET == linux* ]]; then
        rm -r "$FFBUILD_PREFIX"/bin "$FFBUILD_PREFIX"/lib/*.so*
    else
        echo "Unknown target"
        return -1
    fi
}

ffbuild_configure() {
    echo --enable-libshaderc
}

ffbuild_unconfigure() {
    [[ $ADDINS_STR == *4.4* ]] && return 0
    echo --disable-libshaderc
}
