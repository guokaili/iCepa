#!/bin/bash

if [[ ${ACTION:-build} = "build" ]]; then
    if [[ $PLATFORM_NAME = "macosx" ]]; then
        TARGET_OS="darwin"
    else
        TARGET_OS="ios"
    fi

    for ARCH in $ARCHS
    do
        if [[ $(lipo -info "${BUILT_PRODUCTS_DIR}/libtun2tor.a" 2>&1) != *"${ARCH}"* ]]; then
            cargo clean
        fi
    done

    LIBRARIES=()
    for ARCH in $ARCHS
    do
        cargo build --release --lib --target "${ARCH}-apple-${TARGET_OS}"
        LIBRARIES+=("target/${ARCH}-apple-${TARGET_OS}/release/libtun2tor.a")
    done

    xcrun --sdk $PLATFORM_NAME lipo -create $LIBRARIES -output "${BUILT_PRODUCTS_DIR}/libtun2tor.a"
elif [[ ${ACTION:-build} = "clean" ]]; then
    cargo clean
    rm -f "${BUILT_PRODUCTS_DIR}/libtun2tor.a"
fi
