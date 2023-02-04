'''
Created on Jan 7, 2023

@author: othon
'''

def crc32mpeg2(buf, crc):
    crc ^= 0xffffffff
    for val in buf:
        crc ^= val << 24
        for i in range(8):
            msb = crc >> 31
            crc = (crc << 1) ^ (0 - msb) & 0x104c11db7;
            # crc = crc << 1 if (crc & 0x80000000) == 0 else (crc << 1) ^ 0x104c11db7
    return crc

def get_crc32mpeg2_hash(filename):
    with open(filename, mode="rb") as f:
        return crc32mpeg2(f.read(), 0)