#!/bin/bash

SCRIPT_REPO="https://chromium.googlesource.com/webm/libvpx"
SCRIPT_COMMIT="b2c2955c8200ff434f178009df41a1e1e1623156"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    cd "$FFBUILD_DLDIR/$SELF"

    local myconf=(
        --disable-shared
        --enable-static
        --enable-pic
        --disable-examples
        --disable-tools
        --disable-docs
        --disable-unit-tests
        --enable-vp9-highbitdepth
        --prefix="$FFBUILD_PREFIX"
    )

    if [[ $TARGET == win64 ]]; then
        myconf+=(
            --target=x86_64-win64-gcc
        )
        export CROSS="$FFBUILD_CROSS_PREFIX"
    elif [[ $TARGET == win32 ]]; then
        myconf+=(
            --target=x86-win32-gcc
        )
        export CROSS="$FFBUILD_CROSS_PREFIX"
    elif [[ $TARGET == linux64 ]]; then
        myconf+=(
            --target=x86_64-linux-gcc
        )
        export CROSS="$FFBUILD_CROSS_PREFIX"
    elif [[ $TARGET == linux32 ]]; then
        myconf+=(
            --target=x86-linux-gcc
        )
        export CROSS="$FFBUILD_CROSS_PREFIX"
    elif [[ $TARGET == linuxarm64 ]]; then
        myconf+=(
            --target=arm64-linux-gcc
        )
        export CROSS="$FFBUILD_CROSS_PREFIX"
    elif [[ $TARGET == macos64 ]]; then
        myconf+=(
            --target=x86_64-darwin21-gcc
        )
        export CROSS="$FFBUILD_CROSS_PREFIX"
    elif [[ $TARGET == macosarm64 ]]; then
        myconf+=(
            --target=arm64-darwin21-gcc
        )
        export CROSS="$FFBUILD_CROSS_PREFIX"
    else
        echo "Unknown target"
        return -1
    fi

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install

    # Work around strip breaking LTO symbol index
    "$RANLIB" "$FFBUILD_PREFIX"/lib/libvpx.a
}

ffbuild_configure() {
    echo --enable-libvpx
}

ffbuild_unconfigure() {
    echo --disable-libvpx
}
