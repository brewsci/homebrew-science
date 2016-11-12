class Paraview < Formula
  desc "Multi-platform data analysis and visualization application"
  homepage "http://paraview.org"
  url "http://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.1&type=source&os=all&downloadFile=ParaView-v5.1.2.tar.gz"
  sha256 "ff02b7307a256b7c6e8ad900dee5796297494df7f9a0804fe801eb2f66e6a187"

  head "git://paraview.org/ParaView.git"

  bottle do
    sha256 "2bb1f3b68796fc87cc43f8ddf0b00be68b37192c161b287efd01680052499dcf" => :sierra
    sha256 "1a53c8702e2ade9cad5a3f58a799b277da8ca016fa122552703e5a9e60e5f90e" => :el_capitan
    sha256 "c4c702028dd6784792be8fdc7d8e77cfc565b8d3a0ef6f14f6096e5f268e2fde" => :yosemite
  end

  depends_on "cmake" => :build

  depends_on "boost" => :recommended
  depends_on "cgns" => :recommended
  depends_on "ffmpeg" => :recommended
  depends_on "qt5" => :recommended
  depends_on :mpi => [:cc, :cxx, :optional]
  depends_on :python => :recommended

  depends_on "freetype"
  depends_on "hdf5"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "fontconfig"
  depends_on "libpng"

  def install
    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_TESTING=OFF
      -DMACOSX_APP_INSTALL_PREFIX=#{prefix}
      -DPARAVIEW_DO_UNIX_STYLE_INSTALLS:BOOL=OFF
      -DPARAVIEW_QT_VERSION=5
      -DVTK_USE_SYSTEM_EXPAT:BOOL=ON
      -DVTK_USE_SYSTEM_FREETYPE:BOOL=ON
      -DVTK_USE_SYSTEM_HDF5:BOOL=ON
      -DVTK_USE_SYSTEM_JPEG:BOOL=ON
      -DVTK_USE_SYSTEM_LIBXML2:BOOL=ON
      -DVTK_USE_SYSTEM_PNG:BOOL=ON
      -DVTK_USE_SYSTEM_TIFF:BOOL=ON
      -DVTK_USE_SYSTEM_ZLIB:BOOL=ON
    ]

    args << "-DPARAVIEW_BUILD_QT_GUI:BOOL=OFF" if build.without? "qt5"
    args << "-DPARAVIEW_USE_MPI:BOOL=ON" if build.with? "mpi"
    args << "-DPARAVIEW_ENABLE_FFMPEG:BOOL=ON" if build.with? "ffmpeg"
    args << "-DPARAVIEW_USE_VISITBRIDGE:BOOL=ON" if build.with? "boost"
    args << "-DVISIT_BUILD_READER_CGNS:BOOL=ON" if build.with? "cgns"
    args << "-DPARAVIEW_ENABLE_PYTHON:BOOL=" + ((build.with? "python") ? "ON" : "OFF")

    mkdir "build" do
      # Python3 support is being worked on, see https://gitlab.kitware.com/paraview/paraview/issues/16818
      if build.with? "python"
        python_executable = `which python`.strip
        python_prefix = `#{python_executable} -c 'import sys;print(sys.prefix)'`.chomp
        python_include = `#{python_executable} -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))'`.chomp
        python_version = "python" + `#{python_executable} -c 'import sys;print(sys.version[:3])'`.chomp

        args << "-DPYTHON_EXECUTABLE='#{python_executable}'"
        args << "-DPYTHON_INCLUDE_DIR='#{python_include}'"

        # CMake picks up the system's python dylib, even if we have a brewed one.
        if File.exist? "#{python_prefix}/Python"
          args << "-DPYTHON_LIBRARY='#{python_prefix}/Python'"
        elsif File.exist? "#{python_prefix}/lib/lib#{python_version}.a"
          args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/lib#{python_version}.a'"
        else
          args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/lib#{python_version}.dylib'"
        end
      end
      args << ".."

      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    assert_match "paraview version 5.1.2", shell_output("#{opt_prefix}/paraview.app/Contents/MacOS/paraview --version 2>&1", 0)
  end
end
