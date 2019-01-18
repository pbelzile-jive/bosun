#!/bin/sh
set -e
OUTPUTDIR="./cmd/scollector/bin/"
mkdir -p $OUTPUTDIR
OUTPUTDIR=$(cd $OUTPUTDIR; pwd)/

TIME=`date +%Y%m%d%H%M%S`
export GIT_SHA=`cd $GOPATH/src/bosun.org; git rev-parse HEAD`

build()
{
	export GOOS=$1
	export GOARCH=$2
	EXT=""
	if [ $GOOS = "windows" ]; then
		EXT=".exe"
	fi
	go build -o ${OUTPUTDIR}scollector-$GOOS-$GOARCH$EXT -ldflags "-X bosun.org/_version.VersionSHA=$GIT_SHA -X bosun.org/_version.OfficialBuild=true -X bosun.org/_version.VersionDate=$TIME" bosun.org/cmd/scollector
}

echo "Output directory: $OUTPUTDIR"

for GOOS in linux darwin; do
	for GOARCH in amd64 386; do
		build $GOOS $GOARCH
	done
done
