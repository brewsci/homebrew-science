require "formula"

class Gdcm < Formula
  homepage "http://sourceforge.net/projects/gdcm/"
  url "https://downloads.sourceforge.net/project/gdcm/gdcm%202.x/GDCM%202.4.4/gdcm-2.4.4.tar.bz2"
  sha1 "4b77a857cf8432da72140a5e7d20f78c091ee019"

  bottle do
    sha1 "e568685ac9b074e9d011572ec1c44739e222285b" => :yosemite
    sha1 "680770f722affd0f053289fcd5181c64ae439dba" => :mavericks
    sha1 "55a0dd18c8900f6a8761d358bfbbb9d7bef5e6d0" => :mountain_lion
  end

  option "with-check", "Run the GDCM test suite"
  depends_on :python => :optional
  depends_on :python3 => :optional

  option :cxx11
  cxx11dep = (build.cxx11?) ? ['c++11'] : []

  depends_on "cmake" => :build
  depends_on "vtk" => [:optional] + cxx11dep
  depends_on "swig" => :build if build.with? "python" or build.with? "python3"

  if build.with? "python" and build.with? "python3"
    raise "Recipe may only be installed for one python type."
  end

  def install
    sourcedir = "#{pwd}/source_files"
    builddir = "#{pwd}/build_files"

    targets = Dir.glob("*")

    mkdir sourcedir
    targets.each do |target|
      mv target, File.join(sourcedir, File.basename(target))
    end
    mkdir builddir do
      args = std_cmake_args

      if build.with? "python" or build.with? "python3"
        python_executable = `which python`.strip if build.with? "python"
        python_executable = `which python3`.strip if build.with? "python3"

        python_prefix = %x(#{python_executable} -c 'import sys;print(sys.prefix)').chomp
        python_include = %x(#{python_executable} -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))').chomp
        python_version = "python" + %x(#{python_executable} -c 'import sys;print(sys.version[:3])').chomp
        py_site_packages = "#{lib}/#{python_version}/site-packages"

        args << "-DPYTHON_EXECUTABLE='#{python_executable}'"
        args << "-DPYTHON_INCLUDE_DIR='#{python_include}'"
        if File.exist? "#{python_prefix}/Python"
          args << "-DPYTHON_LIBRARY='#{python_prefix}/Python'"
        elsif File.exist? "#{python_prefix}/lib/lib#{python_version}.a"
          args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/lib#{python_version}.a'"
        else
          args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/lib#{python_version}.dylib'"
        end
        args << "-DGDCM_WRAP_PYTHON=ON"
        args << "-DGDCM_INSTALL_PYTHONMODULE_DIR='#{py_site_packages}'"
      end

      args << "-DGDCM_BUILD_APPLICATIONS=ON"
      args << "-DGDCM_BUILD_EXAMPLES=ON"
      args << "-DGDCM_BUILD_SHARED_LIBS=ON"
      args << "-DGDCM_BUILD_TESTING=ON" if build.with? "check"
      args << "-DGDCM_USE_VTK=ON" if build.with? "vtk"
      args << sourcedir

      system "cmake", *args

      system "make"
      system "make", "test" if build.with? "check"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/gdcminfo", "--version"
  end
end
