#!/bin/bash

# check CONFIG_DEBUG_INFO_BTF=y
grep "CONFIG_DEBUG_INFO_BTF=y" /boot/config-$(uname -r)
