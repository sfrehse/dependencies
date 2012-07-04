#!/bin/sh


if [ -z "$build" ] ; then 
  echo '$build is undefined'
  exit 1
fi
if [ -z "$package_dir" ] ; then 
  echo '$package_dir is undefined'
  exit 1
fi



package=tcl 
version=8.5.11
source=$package$version-src.tar.gz
build_dir=$build/$package$version
url=http://downloads.sourceforge.net/project/tcl/Tcl/$version/$source 

download_unpack() {
  cd $build && download_http $source "$url" && tar -xf $source 
}


pre_build() {
  cd $build_dir/unix  &&
  ./configure --prefix=$target 
}

build_install() {
  if [ -z "$target" ] ; then 
    echo '$target is undefined'
    exit 1
  fi
  cd $build_dir/unix && make && make install && 

  sharePath=$target/share/tcl$version
  mkdir -p $sharePath
  cat > $sharePath/tcl-config.cmake << eom
set(tcl_VERSION $version)
set(tcl_BIN_DIRS     $target/bin)
set(tcl_INCLUDE_DIRS $target/include)
set(tcl_LIB_DIR      $target/lib/tcl8.5)
set(tcl_LIBRARIES    $target/lib/libtcl8.5.so $target/lib/libtk8.5.so  )
eom

   cat > $sharePath/tcl-config-version.cmake << eom
if("\${PACKAGE_FIND_VERSION}" VERSION_EQUAL $version)
set(PACKAGE_VERSION_EXACT 1)
set(PACKAGE_VERSION_COMPATIBLE 1)
endif("\${PACKAGE_FIND_VERSION}" VERSION_EQUAL $version) 
eom

}
