#!/bin/sh


if [ -z "$build" ] ; then 
  echo '$build is undefined'
  exit 1
fi
if [ -z "$package_dir" ] ; then 
  echo '$package_dir is undefined'
  exit 1
fi


package=cleaneling
version=00a
source=$package$version.zip
build_dir=$build/$package$version
url=http://fmv.jku.at/cleaneling/$source

download_unpack() {
  if [ "$duplicate" = "remove" ]; then
    rm -rf $build_dir
  fi
  mkdir -p $(dirname $build_dir) &&
  cd $(dirname $build_dir) &&
  [ -f $source ] || wget -O $source $url &&
  unzip $source 
  mv cleaneling $package$version 
}


pre_build() {
  cd $build_dir &&
  install_cmake_files
}

build_install() {
  if [ -z "$target" ] ; then 
    echo '$target is undefined'
    exit 1
  fi
  cd $build_dir &&
  cmake_build_install
}
