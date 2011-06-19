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
  url 'http://qgis.org/downloads/qgis-1.7.0.tar.bz2'
  md5 'd8506990f52563d39c7b916f500f282f'

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
    internal_qwt = prefix + 'qwt52'

    Qwt52.new.brew do
      inreplace 'qwtconfig.pri' do |s|
        # change_make_var won't work because there are leading spaces
        s.gsub! /^\s*QWT_INSTALL_PREFIX\s*=(.*)$/, "QWT_INSTALL_PREFIX=#{internal_qwt}"
        s.gsub! /^\s*INSTALLBASE\s*=(.*)$/, "INSTALLBASE=#{internal_qwt}"
      end

      system "qmake -config release"
      system "make install"
    end

    Dir.mkdir('build')
    Dir.chdir('build')

    cmake_args = std_cmake_parameters.split
    cmake_args << "-DQWT_INCLUDE_DIR=#{internal_qwt}/include"
    cmake_args << "-DQWT_LIBRARY=#{internal_qwt}/lib/libqwt.dylib"

    if grass?
      grass = Formula.factory('grass')
      cmake_args << "-DGRASS_PREFIX=#{Dir[grass.prefix + 'grass-*']}"
    end

    system "cmake", "..", *cmake_args
    system "make install"

    # Create script to launch QGIS app
    (bin + 'qgis').write <<-EOS.undent
      #!/bin/sh
      open #{prefix}/QGIS.app
    EOS

    # Symlink the PyQGIS Python module somewhere convienant for users to put on
    # their PYTHONPATH
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
