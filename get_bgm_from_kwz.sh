#!/bin/bash

if [ -z $1 ]; then
	echo "Usage: $0 file.kwz";
	exit 1;
fi

#1 go to start of ksn section (starts at 0x4B534E01)
#2 data (all 32-bit LE unsigned ints):
	# - section length
	# - recording speed
	# - bgm length
	# - se1 length
	# - se2 length
	# - se3 length
	# - se4 length
#3 - 4 byte crc32 checksum
#4 - audio data - may start with crc32
	# - bgm
	# - se1
	# - se2
	# - se3
	# - se4

# Get header section

# convert big endian to little endian
be_to_le () {
	tac -rs .. | echo "$(tr -d '\n')"
}

KSN_START=$(($(cat $1|xxd -p -c 4|tr -d '\n'|grep -Po "^.+?(?=4b534e)"|wc -c) / 2))
HEADER=$(cat $1|xxd -p -c 4|tr -d '\n'|grep -Po "4b534e..(.){50}")
HEADER_LENGTH=32
SECTION_LENGTH=$(printf ${HEADER:8:8}|be_to_le)
RECORDING_SPEED=$(printf ${HEADER:16:8}|be_to_le)
BGM_LENGTH=$(printf ${HEADER:24:8}|be_to_le)
SE1_LENGTH=$(printf ${HEADER:32:8}|be_to_le)
SE2_LENGTH=$(printf ${HEADER:40:8}|be_to_le)
SE3_LENGTH=$(printf ${HEADER:48:8}|be_to_le)
SE4_LENGTH=$(printf ${HEADER:56:8}|be_to_le)

echo KSN Start: $KSN_START >&2
echo Section Length: $((16#${SECTION_LENGTH})) >&2 # may need off by one
echo Recording Speed: $((16#${RECORDING_SPEED})) >&2
echo BGM Length: $((16#${BGM_LENGTH})) >&2 # off by one..?
echo SE1 Length: $((16#${SE1_LENGTH})) >&2 # off by one..?
echo SE2 Length: $((16#${SE2_LENGTH})) >&2 # off by one..?
echo SE3 Length: $((16#${SE3_LENGTH})) >&2 # off by one..?
echo SE4 Length: $((16#${SE4_LENGTH})) >&2 # off by one..?

# Everything between BGM_LENGTH and SE4_LENGTH
#head -c$(($KSN_START + $((16#${SECTION_LENGTH})))) $1|tail -c$((16#${SECTION_LENGTH}-32-4))

# There might be 4 bytes of CRC at the beginning of each audio section so we need to not include those

# Play BGM, SFX1, and then SFX2 -- omitting the first 4 bytes of each

# BGM
#head -c$(($KSN_START + $((16#${SECTION_LENGTH})))) $1|tail -c$((16#${SECTION_LENGTH} - $HEADER_LENGTH - 4))|head -c $((16#${BGM_LENGTH}))
# BGM with a bit chopped out to remove screech
head -c$(($KSN_START + $((16#${SECTION_LENGTH})))) $1|tail -c$((16#${SECTION_LENGTH} - $HEADER_LENGTH - 4))|head -c $((16#${BGM_LENGTH})) |head -c18000

# SFX1
head -c$(($KSN_START + $((16#${SECTION_LENGTH})))) $1|tail -c$((16#${SECTION_LENGTH}- $HEADER_LENGTH - 16#${BGM_LENGTH} -4 ))|head -c$((16#${SE1_LENGTH})) # the -4 in the second one chops off the first 4 bytes of SE1

# SFX2
head -c$(($KSN_START + $((16#${SECTION_LENGTH})))) $1|tail -c$((16#${SECTION_LENGTH}- $HEADER_LENGTH - 16#${BGM_LENGTH} - 16#${SE1_LENGTH} -4))|head -c$((16#${SE2_LENGTH})) # the -4 in the second one chops off the first 4 bytes of SE2

# SFX3
head -c$(($KSN_START + $((16#${SECTION_LENGTH})))) $1|tail -c$((16#${SECTION_LENGTH}- $HEADER_LENGTH - 16#${BGM_LENGTH} - 16#${SE1_LENGTH} - 16#${SE2_LENGTH} -4))|head -c$((16#${SE3_LENGTH})) # the -4 in the second one chops off the first 4 bytes of SE3

# SFX4
head -c$(($KSN_START + $((16#${SECTION_LENGTH})))) $1|tail -c$((16#${SECTION_LENGTH}- $HEADER_LENGTH - 16#${BGM_LENGTH} - 16#${SE1_LENGTH} - 16#${SE2_LENGTH} - 16#${SE3_LENGTH} -4))|head -c$((16#${SE4_LENGTH})) # the -4 in the second one chops off the first 4 bytes of SE4

