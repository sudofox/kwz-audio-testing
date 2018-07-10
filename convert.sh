#!/bin/bash
if [ -z $2 ]; then
	printf "Usage: ./convert.sh inputfile.bin outputfile.wav\n"
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
for format in $(echo $FORMATS|tr ' ' '\n'); do
	tput setaf 4; echo "== Format: $format =="; tput setaf 5

	# Run the conversion
#	sox -t $format -r 8k -e signed -b 4 $1 $2 || true;
	sox -t $format -r 8k -e signed -b 3 $1 $2 || true;

	tput sgr0
#	sox -t $format -N -r 16k $1 $2 || true;
	mplayer $2;
	sleep 1;
	rm -f $2
done;


