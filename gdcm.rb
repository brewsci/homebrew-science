class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "https://sourceforge.net/projects/gdcm/"
  url "https://downloads.sourceforge.net/project/gdcm/gdcm%202.x/GDCM%202.6.8/gdcm-2.6.8.tar.bz2"
  sha256 "c9b0773313d57871a81277cd3c2fd00f4dd58f9482e165797808c07345fd2a54"

  bottle do
    sha256 "1d6019ae868515bc471a679bb35f363541709567a2210fc8c0c724d62aae1816" => :sierra
    sha256 "e8f8f322297986bd28c4cb40583df11453b9d5aaac608019c259faffc8b493a6" => :el_capitan
    sha256 "633950b04ded8ddc2e0a71b3baa1a21c167c4b275c609343b50d224c717805a7" => :yosemite
    sha256 "10187a123fea71dfb28bf042dff7db0de23c6eb1d4e240a2b7c3f32a0e2f958e" => :x86_64_linux
  end

  deprecated_option "with-check" => "with-test"
  option "with-test", "Run build-time tests"
  option "with-manpages", "Build man pages from XML docbook"

  depends_on :python => :optional
  depends_on :python3 => :optional
  depends_on "openssl" => :optional

  option :cxx11
  cxx11dep = build.cxx11? ? ["c++11"] : []

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
      args << "-DGDCM_BUILD_TESTING=ON" if build.with? "test"
      args << "-DGDCM_BUILD_DOCBOOK_MANPAGES=OFF" if build.without? "manpages"
      args << "-DGDCM_USE_VTK=ON" if build.with? "vtk"
      args << "-DGDCM_USE_SYSTEM_OPENSSL=ON" if build.with? "openssl"
      args << sourcedir

      system "cmake", *args

      system "make"
      system "make", "test" if build.with? "test"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/gdcminfo", "--version"
  end
end
