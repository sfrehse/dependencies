#!/bin/sh


if [ -z "$build" ] ; then 
  echo '$build is undefined'
  exit 1
fi
if [ -z "$package_dir" ] ; then 
  echo '$package_dir is undefined'
  exit 1
fi


package=cppunit
version=1.12.1
source=$package-$version.tar.gz
build_dir=$build/$package-$version
url=http://freefr.dl.sourceforge.net/project/cppunit/cppunit/1.12.1/$source


download_unpack() {
  if [ "$duplicate" = "remove" ]; then
    rm -rf $build_dir
  fi
  mkdir -p $(dirname $build_dir) &&
  cd $(dirname $build_dir) &&
  [ -f $source ] || wget -O $source $url &&
  tar -xf $source
}


pre_build() {
  true
#  cd $build_dir &&
#  install_cmake_files
}

build_install() {
  if [ -z "$target" ] ; then 
    echo '$target is undefined'
    exit 1
  fi

  cd "$build_dir" &&
  ./configure LDFLAGS='-ldl' --prefix=$target &&
  make &&
  make install 

  cat > $target/cppunit-config.cmake <<EOF
set(cppunit_VERSION 1.12.1)
set(cppunit_BIN_DIRS  $target/bin/ )
set(cppunit_INCLUDE_DIRS  $target/include )
set(cppunit_LIBRARIES  $target/lib/libqttestrunner.a $target/lib/libcppunit.a )
EOF

  cat > $target/cppunit-config-version.cmake <<EOF
if("${PACKAGE_FIND_VERSION}" VERSION_EQUAL 1.12.1)
	set(PACKAGE_VERSION_EXACT 1)
	set(PACKAGE_VERSION_COMPATIBLE 1)
endif("${PACKAGE_FIND_VERSION}" VERSION_EQUAL 1.12.1)
EOF
}
