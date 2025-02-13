# FFmpeg Static Auto-Builds

Static Windows (x86_64), macOS (x86_64 and arm64) and Linux (x86_64 and x86_32) Builds of ffmpeg master and latest release branch.

Windows builds are targetting Windows 7 and newer.

macOS (x86_64 and arm64) builds are targetting macOS 12.3 and newer (Monterey - darwin21.4)

Linux (x86_64 and x86_32) builds are targetting Ubuntu 16.04 (glibc-2.23 + linux-4.4) and anything more recent.

Linux (arm64) builds are targetting Ubuntu 18.04 (glibc-2.27 + linux-4.15) and anything more recent.

## Auto-Builds

> [!NOTE]
> Auto-builds on this fork are disabled due to licensing concerns.

## Package List

For a list of included dependencies check the scripts.d directory.
Every file corresponds to its respective package.

## How to make a build

### Prerequisites

* bash
* docker

> [!NOTE]
> To compile for macOS, you'll need to provide the SDK (`MacOSX15.1.sdk.tar.xz`) yourself. This can be extracted from a macOS machine or from downloading Xcode by [follow these instructions](https://github.com/tpoechtrager/osxcross?tab=readme-ov-file#packaging-the-sdk).
>
> Once extracted, place the SDK in the following directories, depending on your target:
> - **x86_64** - `images/base-macos64`
> - **arm64** - `images/base-macosarm64`

### Build Image

* `./makeimage.sh target variant [addin [addin] [addin] ...]`

### Build FFmpeg

* `./build.sh target variant [addin [addin] [addin] ...]`

On success, the resulting zip file will be in the `artifacts` subdir.

### Targets, Variants and Addins

Available targets:
* `win64` (x86_64 Windows)
* `win32` (x86 Windows)
* `macos64` (x86_64 macOS)
* `macosarm64` (arm64 macOS)
* `linux32` (x86_32 Linux, glibc>=2.23, linux>=4.4)
* `linux64` (x86_64 Linux, glibc>=2.23, linux>=4.4)
* `linuxarm64` (arm64 (aarch64) Linux, glibc>=2.27, linux>=4.15)

The linuxarm64 target will not build some dependencies due to lack of arm64 (aarch64) architecture support or cross-compiling restrictions.

* `davs2` and `xavs2`: aarch64 support is broken.
* `libmfx` and `libva`: Library for Intel QSV, so there is no aarch64 support.

Available variants:
* `gpl` Includes all dependencies, even those that require full GPL instead of just LGPL.
* `lgpl` Lacking libraries that are GPL-only. Most prominently libx264 and libx265.
* `nonfree` Includes fdk-aac in addition to all the dependencies of the gpl variant.
* `gpl-shared` Same as gpl, but comes with the libav* family of shared libs instead of pure static executables.
* `lgpl-shared` Same again, but with the lgpl set of dependencies.
* `nonfree-shared` Same again, but with the nonfree set of dependencies.

All of those can be optionally combined with any combination of addins:
* `4.4`/`5.0`/`5.1`/`6.0` to build from the respective release branch instead of master.
* `debug` to not strip debug symbols from the binaries. This increases the output size by about 250MB.
* `lto` build all dependencies and ffmpeg with -flto=auto (HIGHLY EXPERIMENTAL, broken for Windows, sometimes works for Linux)
