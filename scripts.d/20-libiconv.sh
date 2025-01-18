#!/bin/bash

SCRIPT_REPO="https://git.savannah.gnu.org/git/libiconv.git"
SCRIPT_COMMIT="bc17565f9a4caca27161609c526b776287a8270e"

SCRIPT_REPO2="https://git.savannah.gnu.org/git/gnulib.git"
SCRIPT_COMMIT2="e9c1d94f58eaacee919bb2015da490b980a5eedf"

# macOS has iconv in the system, but this one is GNU's iconv. This creates name clash between iconv and libiconv, and
# linker fails to find the correct one. More info at https://stackoverflow.com/questions/57734434/libiconv-or-iconv-undefined-symbol-on-mac-osx
ffbuild_enabled() {
    if [[ $TARGET == macos* ]]; then return -1; fi
    return 0
}

ffbuild_dockerdl() {
    to_df "RUN retry-tool sh -c \"rm -rf $SELF && git clone '$SCRIPT_REPO' $SELF\" && git -C $SELF checkout \"$SCRIPT_COMMIT\""
    to_df "RUN cd $SELF && retry-tool sh -c \"rm -rf gnulib && git clone '$SCRIPT_REPO2' gnulib\" && git -C gnulib checkout \"$SCRIPT_COMMIT2\" && rm -rf gnulib/.git"
}

ffbuild_dockerbuild() {
    cd "$FFBUILD_DLDIR/$SELF"

    # No automake 1.17 packaged anywhere yet.
    sed -i 's/-1.17/-1.16/' Makefile.devel

    (unset CC CFLAGS GMAKE && ./autogen.sh)

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --enable-extra-encodings
        --disable-shared
        --enable-static
        --with-pic
    )

    if [[ $TARGET == win* || $TARGET == linux* || $TARGET == macos* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install
}

ffbuild_configure() {
    echo --enable-iconv
}

ffbuild_unconfigure() {
    echo --disable-iconv
}
