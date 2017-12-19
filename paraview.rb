class Paraview < Formula
  desc "Multi-platform data analysis and visualization application"
  homepage "https://www.paraview.org/"
  url "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.3&type=source&os=all&downloadFile=ParaView-v5.3.0.tar.gz"
  sha256 "046631bbf00775edc927314a3db207509666c9c6aadc7079e5159440fd2f88a0"
  revision 3

  head "https://gitlab.kitware.com/paraview/paraview.git"

  bottle :disable, "needs to be rebuilt with latest boost"

  depends_on "cmake" => :build

  depends_on "boost" => :recommended
  depends_on "ffmpeg" => :recommended
  depends_on "qt" => :recommended
  depends_on :mpi => [:cc, :cxx, :optional]
  depends_on :python => :recommended

  depends_on "freetype"
  depends_on "hdf5"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "fontconfig"
  depends_on "libpng"

  def install
    dylib = OS.mac? ? "dylib" : "so"

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
      -DVTK_USE_SYSTEM_ZLIB:BOOL=NETCDF
    ]

    args << "-DPARAVIEW_BUILD_QT_GUI:BOOL=OFF" if build.without? "qt"
    args << "-DPARAVIEW_USE_MPI:BOOL=ON" if build.with? "mpi"
    args << "-DPARAVIEW_ENABLE_FFMPEG:BOOL=ON" if build.with? "ffmpeg"
    args << "-DPARAVIEW_USE_VISITBRIDGE:BOOL=ON" if build.with? "boost"
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
        elsif File.exist? "#{python_prefix}/lib/lib#{python_version}.#{dylib}"
          args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/lib#{python_version}.#{dylib}'"
        elsif File.exist? "#{python_prefix}/lib/x86_64-linux-gnu/lib#{python_version}.#{dylib}"
          args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/x86_64-linux-gnu/lib#{python_version}.so'"
        else
          odie "No libpythonX.Y.{dylib|so|a} file found!"
        end
      end
      args << ".."

      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    assert_match "paraview version #{version}", shell_output("#{prefix}/paraview.app/Contents/MacOS/paraview --version 2>&1", 0)
  end
end
