# sudofox/kwz-audio-testing

Use play.sh to test out different bitrates, etc. It tries both ima and vox.

Dox for sox: http://sox.sourceforge.net/sox.html

# audio data in kwz

1) go to start of ksn section (starts at 0x4B534E01)
2) data (all 32-bit LE unsigned ints):
	# - section length
	# - recording speed
	# - bgm length
	# - se1 length
	# - se2 length
	# - se3 length
	# - se4 length
3) - 4 byte crc32 checksum
4) - audio data - may start with crc32?
	# - bgm
	# - se1
	# - se2
	# - se3
	# - se4

# sample audio

sampleaudio.bin is from kwz/cmzcsupxfxu0xmka42nwppdujcan.kwz - currently not complete
