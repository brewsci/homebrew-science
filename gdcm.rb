class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "http://sourceforge.net/projects/gdcm/"
  url "https://downloads.sourceforge.net/project/gdcm/gdcm%202.x/GDCM%202.6.5/gdcm-2.6.5.tar.bz2"
  sha256 "2278fab65997fa90fd17dec13e5048b09075ebba07a7d77783bc5d35c5682db8"

  bottle do
    sha256 "fa4b641addcbbc6c0b35baf0c35dce2b426c8f43ac64e69d6139acacd0e014c7" => :el_capitan
    sha256 "442a330bd1b62a8bd20f0be5d92b2270e4f1f8c8206d68b48bebf0bbee97a9c0" => :yosemite
    sha256 "0b305b8b18e1db600eb38519482e642c94c90898fcde1999e0a0c821b1d70ead" => :mavericks
  end

  option "with-check", "Run the GDCM test suite"
  depends_on :python => :optional
  depends_on :python3 => :optional
  depends_on "openssl" => :optional

  option :cxx11
  cxx11dep = (build.cxx11?) ? ["c++11"] : []

  depends_on "cmake" => :build
  depends_on "vtk" => [:optional] + cxx11dep
  depends_on "swig" => :build if build.with?("python") || build.with?("python3")

  if build.with?("python") && build.with?("python3")
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

      if build.with?("python") || build.with?("python3")
        python_executable = `which python`.strip if build.with? "python"
        python_executable = `which python3`.strip if build.with? "python3"

        python_prefix = `#{python_executable} -c 'import sys;print(sys.prefix)'`.chomp
        python_include = `#{python_executable} -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))'`.chomp
        python_version = "python" + `#{python_executable} -c 'import sys;print(sys.version[:3])'`.chomp
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
      args << "-DGDCM_USE_SYSTEM_OPENSSL=ON" if build.with? "openssl"
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
