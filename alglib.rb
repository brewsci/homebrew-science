class Alglib < Formula
  desc "Cross-platform numerical analysis library"
  homepage "http://www.alglib.net"
  url "http://www.alglib.net/translator/re/alglib-3.10.0.cpp.gpl.tgz"
  version "3.10.0"
  sha256 "26a6aa966da5bba01da1bebddc0acb0a8fc579f07d53a2cbcfa5dfcaf612aaeb"

  bottle do
    cellar :any
    sha256 "8e598ccbc0a92205ce55a079e9d0ff6a120675c3350ca6673aae7f5e9d9b48a3" => :sierra
    sha256 "8e598ccbc0a92205ce55a079e9d0ff6a120675c3350ca6673aae7f5e9d9b48a3" => :el_capitan
    sha256 "f0a4fd70b961c25d781f7a2dc9c25980a53a680db5074577c6ffea6fb4665d46" => :yosemite
  end

  depends_on "qt5"
  depends_on "pkg-config" => :build

  def install
    (buildpath/"alglib.pro").write <<-EOS.undent
      TEMPLATE = subdirs
      SUBDIRS = \\
          src
    EOS

    (buildpath/"src/src.pro").write <<-EOS.undent
      isEmpty(PREFIX) {
        PREFIX = /usr/local
      }
      CONFIG      += warn_on release static_and_shared
      QT      -= gui core
      LIBS    -= -lQtGui -lQtCore
      TARGET       = alglib
      VERSION      = 3.10.0
      TEMPLATE     = lib
      target.path = $$PREFIX/lib
      DEPENDPATH += .
      INCLUDEPATH += .
      OBJECTS_DIR  = ../_tmp
      DESTDIR = ../
      HEADERS += *.h
      SOURCES += *.cpp
      header_files.files = $$HEADERS
      header_files.path = $$PREFIX/include/alglib
      INSTALLS += target
      INSTALLS += header_files
      CONFIG += create_pc create_prl no_install_prl
      QMAKE_PKGCONFIG_LIBDIR = $$PREFIX/lib/
      QMAKE_PKGCONFIG_INCDIR = $$PREFIX/include/alglib
      QMAKE_PKGCONFIG_CFLAGS = -I$$PREFIX/include/
      QMAKE_PKGCONFIG_DESTDIR = pkgconfig
    EOS

    system "qmake", "alglib.pro", "PREFIX=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath / "test.cpp").write <<-EOS.undent
      #include <stdlib.h>
      #include <stdio.h>
      #include <time.h>
      #include "dataanalysis.h"
      int main(int argc, char **argv)
      {
          alglib::multilayerperceptron net;
          mlpcreate0(2, 1, net);
          mlprandomize(net);
          return 0;
      }
    EOS
    system ENV.cxx, "-o", "test", "test.cpp", "-L#{lib}", "-lalglib", "-I#{include}/alglib"
    system "./test"
  end
end
