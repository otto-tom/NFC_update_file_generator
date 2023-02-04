#!/bin/python3

import os, sys, mmap
import constants
from pyhash import hash

# total arguments
n = len(sys.argv)
if ( n != 2):
    print("Filename argument should be passed")
    sys.exit(-1);

# get FW file name and size (expected with no extension)
fw_file = sys.argv[1] + '.bin'
fw_file_size = os.stat(fw_file).st_size
fw_file_base = os.path.splitext(fw_file)[0]

# hash = hash.hash()

# calculate FW hash
if constants.HASH_TYPE == 1:
    fw_hash = hash.get_crc32mpeg2_hash(fw_file)
else:
    print('HASH type not supported')
    sys.exit(-2)

# create NFC header basic file
hdr_file = fw_file_base + '_NFCheader.bin'

# create header file
with open(hdr_file, 'w+b') as f:
    # base empty file
    f.write(b'\x00' * constants.NFC_HDR_SIZE)

# construct NFC update file
with open(hdr_file, "r+b") as f:
    # memory-map the file, size 0 means whole file
    mm = mmap.mmap(f.fileno(), 0)
    # write version
    version = ((constants.VER_MAJOR&0x3) << 6) | ((constants.VER_MINOR&0xF) << 2) | (constants.VER_RELAB&0x3)
    mm[0] = version
    # write hash type
    mm[1] = constants.HASH_TYPE
    # write magic number
    mm[8:12] = constants.NFC_HDR_MAGIC
    # write FW size
    mm[12:16] = fw_file_size.to_bytes(4, 'little')
    # write FW hash
    mm[16:] = fw_hash.to_bytes(32, 'little')

    mm.close()

print(hdr_file)