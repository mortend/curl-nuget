#!/bin/bash
set -e

# CURL version
VERSION="7.59.0"

# Build libcurl
pushd curl-$VERSION > /dev/null
cmake -G"Visual Studio 15 2017 Win64" . \
    -DCMAKE_C_FLAGS=" /Fd\"\$(TargetDir)\$(TargetName).pdb\"" \
    -DBUILD_CURL_EXE=OFF \
    -DCURL_STATICLIB=ON

cmake --build . -- //m //p:Configuration=Debug //v:minimal
cmake --build . -- //m //p:Configuration=Release //v:minimal
popd > /dev/null

# Copy headers and libs
rm -rf build
mkdir -p build/native/include/curl build/native/lib
cp curl-$VERSION/include/curl/*.h build/native/include/curl
cp -R curl-$VERSION/lib/Debug curl-$VERSION/lib/Release build/native/lib

# Build nuget package
nuget pack curl-vc141-static-x64.nuspec -Version $VERSION
