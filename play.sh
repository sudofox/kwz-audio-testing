#!/bin/bash
if [ -z $1 ]; then
	printf "Usage: $0 inputfile.bin\n"
	exit 1;
fi

# kind of works: leave for reference
# sox -t ima -N -r 16k $1 $2

# testing below
#sox -t ima -N -r 16k -c 1 -t u8 $1 $2
#sox -q -t ima -N $1 $2
# sox -t ima -N -r 16k $1 $2
#sox -t ima -N -r 16k $1 $2
#sox -b 16 -r 8k -N -t ima $1 $2

#FORMATS="cdda cdr cvs cvsd cvu dat hcom htk ima ircam la lpc lpc10 lu mat mat4 mat5 maud mp2 mp3 nist ogg paf prc pvf raw s1 s16 s2 s24 s3 s32 s4 s8 sb sd2 sds sf sl sln smp snd sndfile sndr sndt sou sox sph sw txw u1 u16 u2 u24 u3 u32 u4 u8 ub ul uw vms voc vorbis vox w64 wavpcm wv wve xa xi"
FORMATS="ima vox"
FORMATS="ima"
for format in $(echo $FORMATS|tr ' ' '\n'); do
	tput setaf 4; echo "== Format: $format =="; tput setaf 5

	# Run the conversion
#	sox -t $format -r 8k -e signed -b 4 $1 $2 || true;
	play -t $format -r 16k -e signed -b 4 -N $1 || true;

	tput sgr0
done;


