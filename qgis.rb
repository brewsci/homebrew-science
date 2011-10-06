require 'formula'

def grass?
  ARGV.include? "--with-grass"
end

def postgis?
  ARGV.include? "--with-postgis"
end

def py_version
  `python -c 'import sys;print sys.version[:3]'`.chomp
end

# QGIS can't build against QWT 6.x. So, we use an internal brew of QWT 5.2.2.
class Qwt52 < Formula
  url 'http://sourceforge.net/projects/qwt/files/qwt/5.2.2/qwt-5.2.2.tar.bz2'
  homepage 'http://qwt.sourceforge.net'
  md5 '70d77e4008a6cc86763737f0f24726ca'
end

class Qgis <Formula
  homepage 'http://www.qgis.org'
  head 'git://github.com/qgis/Quantum-GIS.git', :branch => 'master'
  url 'http://qgis.org/downloads/qgis-1.7.1.tar.bz2'
  md5 '677dcb9d0d53cc7c2a6451590a362477'

  def options
    [
      ['--with-grass', 'Build support for GRASS GIS.'],
      ['--with-postgis', 'Build support for PostGIS databases.']
    ]
  end

  depends_on 'cmake' => :build

  depends_on 'gsl'
  depends_on 'PyQt'
  depends_on 'gdal'

  depends_on 'grass' if grass?
  depends_on 'gettext' if grass? # For libintl

  depends_on 'postgis' if postgis?

  def install
    internal_qwt = Pathname.new(Dir.getwd) + 'qwt52'

    Qwt52.new.brew do
      inreplace 'qwtconfig.pri' do |s|
        # change_make_var won't work because there are leading spaces
        s.gsub! /^\s*QWT_INSTALL_PREFIX\s*=(.*)$/, "QWT_INSTALL_PREFIX=#{internal_qwt}"
        s.gsub! /^\s*INSTALLBASE\s*=(.*)$/, "INSTALLBASE=#{internal_qwt}"
        # Removing the `QwtDll` config option will cause Qwt to build as a
        # satic library. We could build dynamic, but we would need to hit the
        # results with `install_name_tool` to make sure the paths are right. As
        # the QGIS main executable seems to be the only thing that links
        # against this, I'm keeping it simple with a static lib.
        s.gsub! /^(\s*CONFIG.*QwtDll)$/, ''
      end

      system 'qmake -spec macx-g++ -config release'
      system 'make install'
    end

    cmake_args = std_cmake_parameters.split
    cmake_args << "-DQWT_INCLUDE_DIR=#{internal_qwt}/include"
    cmake_args << "-DQWT_LIBRARY=#{internal_qwt}/lib/libqwt.a"

    if grass?
      grass = Formula.factory 'grass'
      gettext = Formula.factory 'gettext'
      cmake_args << "-DGRASS_PREFIX=#{Dir[grass.prefix + 'grass-*']}"
      # So that `libintl.h` can be found
      ENV.append 'CXXFLAGS', "-I#{gettext.include}"
    end

    Dir.mkdir 'build'
    Dir.chdir 'build' do
      system "cmake", "..", *cmake_args
      system "make install"
    end

    # Create script to launch QGIS app
    (bin + 'qgis').write <<-EOS.undent
      #!/bin/sh
      open #{prefix}/QGIS.app
    EOS

    # Symlink the PyQGIS Python module somewhere convienant for users to put on
    # their PYTHONPATH
    #
    # NOTE: It looks like there may now be a CMake option to do this for us.
    py_lib = lib + "python#{py_version}/site-packages"
    qgis_modules = prefix + 'QGIS.app/Contents/Resources/python/qgis'

    py_lib.mkpath
    ln_s qgis_modules, py_lib + 'qgis'
  end

  def caveats
    <<-EOS
QGIS has been built as an application bundle. To make it easily available, you
may want to consider running:

    brew linkapps

or:

    ln -s #{prefix}/QGIS.app /Applications

The QGIS python modules have been symlinked to:

  #{HOMEBREW_PREFIX}/python#{py_version}/site-packages

If you are interested in PyQGIS development, then you will need to ensure this
directory is on your PYTHONPATH.
    EOS
  end
end
