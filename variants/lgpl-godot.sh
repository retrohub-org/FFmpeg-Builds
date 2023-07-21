FF_CONFIGURE="$FF_CONFIGURE --disable-hwaccels --disable-filters --disable-programs --disable-network --disable-encoders --disable-avdevice --disable-muxers --disable-indevs --disable-outdevs --disable-vulkan --disable-decoders --disable-demuxers"
VORBIS="--enable-libvorbis --enable-parser=vorbis --enable-decoder=vorbis --enable-decoder=libvorbis"
VP9="--enable-demuxer=matroska --enable-decoder=vp9 --enable-parser=vp9"
VP8="--enable-decoder=vp8 --enable-parser=vp8"
H264="--enable-decoder=mpeg4,h264,aac,aac_latm,mp3 --enable-demuxer=mov,aac,flv,avi --enable-parser=h264,mpeg4video,mpegaudio,mpegvideo,aac,aac_latm"
OPUS="--enable-libopus --enable-parser=opus --enable-decoder=opus --enable-decoder=libopus"

FF_CONFIGURE="$FF_CONFIGURE $VORBIS $VP9 $VP8 $H264 $OPUS"
