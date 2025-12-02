#!/bin/bash

set -e #Stop on any error

__NV_PRIME_RENDER_OFFLOAD=1 \
__GLX_VENDOR_LIBRARY_NAME=nvidia \
"$@"
