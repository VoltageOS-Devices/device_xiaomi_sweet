#!/bin/bash
#
# Copyright (C) 2020 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

DEVICE=sweet
VENDOR=xiaomi

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ARROW_ROOT="${MY_DIR}"/../../..

HELPER="${ARROW_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        -f | --force )
                FORCE=true
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

# Get the host OS
HOST="$(uname | tr '[:upper:]' '[:lower:]')"
PATCHELF_TOOL="${ARROW_ROOT}/prebuilts/tools-extras/${HOST}-x86/bin/patchelf"

# Check if prebuilt patchelf exists
if [ -f $PATCHELF_TOOL ]; then
    echo "Using prebuilt patchelf at $PATCHELF_TOOL"
else
    # If prebuilt patchelf does not exist, use patchelf from PATH
    PATCHELF_TOOL="patchelf"
fi

# Do not continue if patchelf is not installed
if [[ $(which patchelf) == "" ]] && [[ $PATCHELF_TOOL == "patchelf" ]] && [[ $FORCE != "true" ]]; then
    echo "The script will not be able to do blob patching as patchelf is not installed."
    echo "Run the script with the argument -f or --force to bypass this check"
    exit 1
fi


if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
    vendor/lib64/hw/camera.qcom.so)
        $PATCHELF_TOOL --remove-needed "libMegviiFacepp-0.5.2.so" "${2}"
        $PATCHELF_TOOL --remove-needed "libmegface.so" "${2}"
        $PATCHELF_TOOL --add-needed "libshim_megvii.so" "${2}"
        ;;
    vendor/lib64/libsdmcore.so)
        # This patch is valid for libsdmcore @ v13.0.8.0 SKFMIXM
        LIBSDMCORE_SHASUM="c1fb37069254edeefc008e290490825719d9af4c"
        echo "Patching libsdmcore"

        xxd -p "${2}" > /tmp/libsdmcore.hex

        sed -i s:2b18621e:1f2003d5:g /tmp/libsdmcore.hex
        sed -i s:00540a18621e4:00541f2003d54:g /tmp/libsdmcore.hex

        xxd -r -p /tmp/libsdmcore.hex "${2}"

        rm /tmp/libsdmcore.hex

        echo "Done, checking the sha1sum"
        echo "${LIBSDMCORE_SHASUM} ${2}" | sha1sum -c
        sleep 2
        ;;
    system_ext/lib64/lib-imsvideocodec.so)
        $PATCHELF_TOOL --add-needed "libgui-shim.so" "${2}"
    esac
}

# Initialize the helper for common device
setup_vendor "${DEVICE}" "${VENDOR}" "${ARROW_ROOT}" true "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" \
        "${KANG}" --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh" "${SRC}"
