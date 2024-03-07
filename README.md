# DragonDrop File Renamer

This application is a simple file rename tool that uses
drag'n'drop method to rearrange and then rename files.
In particular, very useful for making playlists of any sorts.

It uses Qt6 and runs on Windows.

Also, this application may serve as an example of how to make
Qt Quick desktop applications.

## How to use

Using DDFR is straightforward:

1. Open DDFR and navigate to target directory with files
2. Select any file in a target folder and open it to open target folder
  > *NOTE:* See Limitations section
  
3. Reorder files using drag and drop method
4. Choose filters, if needed
  > *NOTE:* See Limitations section
  
5. Choose prefix
6. Hit **Rename** button and confirm renaming operation

## Limitations

Program has several limitations to keep in mind:

1. Selecting a file to open a folder
  > That's a tradeoff, because Qt Quick (as of v.6.6.2) doesn't offer
  > option to select folder out of the box. Instead, such option is offered via
  > experimental package that pulls entire Qt Widgets (bigger executable size)
  > and requires program redesign.

2. Filter for old prefix detection will strip numbers at line start
  > This filter strips a possible old prefix consisting of numbers,
  > whitespace and some symbols from the start of file name.
  > Consequently, if a filename starts with number, then this number
  > will be stripped until letters are found.

## How to build

DDFR was originally developed with Qt v.6.2.1 and later ported to Qt v.6.6.2,
which is the recommended version to use.

**WARNING:** Keep in mind that latest Qt version might introduce breaking
changes and require additional porting.

### Getting Qt

There are several options to get Qt

#### 1. Downloading via installer

You can download Qt via [Qt Installer](https://www.qt.io/download).
This requires signing up Qt account.

#### 2. Using MSYS2

Get [MSYS2](https://www.msys2.org/) and install `qt-*` packages.
  
For example, if you will use **MinGWw64** platform, then required packages are:

```  
mingw-w64-x86_64-yaml-cpp
mingw-w64-x86_64-qt6-base
mingw-w64-x86_64-qt6-declarative
```

*NOTE:* You can also use MSYS2 as a build environment

The MSYS2 Qt installation **may** have issues:

1. In Qt Creator, adding installation in Qt Version shows
warning *'No QML utility installed'*
  > There's no `qml.exe` file for some reason.
  > Copy `qml-qt6.exe` and rename it to `qml.exe`

2. The `mingw-w64-x86_64-qt6-static` package is not working
  > It has issues with dependency libraries (something like:
  > *IMPORTED_IMPLIB not set for imported target "harfbuzz::harfbuzz"*).
  > You need to build static Qt library yourself (see below).

#### 3. Building Qt from source code

Follow [Building Qt 6 from Git]() instructions and *git* the Qt source code :) Alternatively, download source code from [Qt archive](https://download.qt.io/)

Very likely you would want to build a **static** version of Qt,
so here's my shortcut for MSYS2:

```
$ mkdir <path>/qt-6.6.2-mingw64-static-build
$ cd <path>/qt-6.6.2-mingw64-static-build
$ ../qt-everywhere-src-6.6.2/configure \
  -prefix "<path>/qt-6.6.2-mingw64-static" \
  -platform win32-g++ -release -static -static-runtime -optimize-size \
  -feature-relocatable -no-pch -opengl desktop \
  -skip qtwebengine -nomake tests -nomake examples \
  -qt-pcre -qt-zlib -qt-freetype -qt-harfbuzz -qt-doubleconversion -qt-libb2 \
  -qt-libmd4c -qt-libpng -qt-libjpeg -qt-tiff -qt-webp \
  -no-feature-zstd -no-feature-mng -no-feature-jasper -no-feature-system-assimp \
  -no-feature-qt3d-system-assimp -no-feature-system-doubleconversion \
  -no-feature-system-libb2 -no-feature-system-textmarkdownreader \
  -no-feature-brotli -opensource -confirm-license \
  -- -Wno-dev --fresh
$ cmake --build . --parallel
$ cmake --install .
```

Those are very specific options, you can set your own and specify your **\<path\>**

### Building with CMake

Make sure your build environment has compiler, cmake, Qt and their
dependencies installed.

For MSYS2, you can use following commands:

```
$ mkdir <path>/ddfr-build
$ cd <path>/ddfr-build
$ cmake -DCMAKE_PREFIX_PATH=<path-to-qt> -S <path>/ddfr-source -B .
$ cmake --build . --config MinSizeRel --parallel
$ cmake --install . --prefix "<path>/ddfr-install"
```

### Building with QtCreator

If you have QtCreator, you need to set up proper *Qt Version* and *Kit*.

Then, *Open Project* and navigate to `CMakeLists.txt` file.
Choose build type and build application.

## License

This project is licensed under [GPLv3 License](LICENSE).
