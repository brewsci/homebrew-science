class Alglib < Formula
  homepage "http://www.alglib.net"
  url "http://alglib.net/translator/re/alglib-2.6.0.cpp.zip"
  version "2.6.0"
  sha256 "63bd26576ea579c48b08b4bc1cd42615d93e43ac580d0961aa81613dfd6b5e36"

  depends_on "qt"
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
      VERSION      = 2.6.0
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
      #include "mlpbase.h"
      int main(int argc, char **argv)
      {
          multilayerperceptron net;
          mlpcreate0(2, 1, net);
          mlprandomize(net);
          return 0;
      }
    EOS
    system ENV.cxx, "-o", "test", "test.cpp", "-L#{lib}", "-lalglib", "-I#{include}/alglib"
    system "./test"
  end
end
