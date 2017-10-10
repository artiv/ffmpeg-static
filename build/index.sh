#!/bin/sh
cd $(dirname $0)

tar_exec=$(command -v gtar)
if [ $? -ne 0 ]; then
	tar_exec=$(command -v tar)
fi

download () {
	curl -L -# -A 'https://github.com/eugeneware/ffmpeg-static' -o $2 $1
}

echo 'windows x64'
echo '  downloading from ffmpeg.zeranoe.com'
download 'https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-latest-win64-static.zip' win32-x64.zip
echo '  extracting'
unzip -o -d ../bin/win32/x64 -j win32-x64.zip '**/ffmpeg.exe'

echo 'windows ia32'
echo '  downloading from ffmpeg.zeranoe.com'
download 'https://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-latest-win32-static.zip' win32-ia32.zip
echo '  extracting'
unzip -o -d ../bin/win32/ia32 -j win32-ia32.zip '**/ffmpeg.exe'

echo 'linux x64'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz' linux-x64.tar.xz
echo '  extracting'
$tar_exec -x -C ../bin/linux/x64 --strip-components 1 -f linux-x64.tar.xz --wildcards '*/ffmpeg'

echo 'linux ia32'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-32bit-static.tar.xz' linux-ia32.tar.xz
echo '  extracting'
$tar_exec -x -C ../bin/linux/ia32 --strip-components 1 -f linux-ia32.tar.xz --wildcards '*/ffmpeg'

echo 'darwin x64 – downloading from Homebrew bottles'
bottle_url=$(brew info --json=v1 ffmpeg | ./bottle-url.js)
if [ $? -ne 0 ]; then exit 1; fi
download $bottle_url darwin-x64-ffmpeg.tar.gz
$tar_exec -x -C ../bin/darwin/x64 --strip-components 3 -f darwin-x64-ffmpeg.tar.gz --wildcards '*/bin/ffmpeg'
