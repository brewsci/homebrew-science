class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "https://sourceforge.net/projects/gdcm/"
  url "https://downloads.sourceforge.net/project/gdcm/gdcm%202.x/GDCM%202.8.2/gdcm-2.8.2.tar.gz"
  sha256 "5462c7859e01e5d5d0fb86a19a6c775484a6c44abd8545ea71180d4c41bf0f89"

  bottle do
    sha256 "44b6728faf957bd891f399f112f1a19b56ed9d351e3de024febe2a3c2cb25de6" => :sierra
    sha256 "9a8190a7371ff6353e830ec6264b0aec0699cbcfeb2ec35c9718bba887bce876" => :el_capitan
    sha256 "a32339df85328b79aecd158f1765f1ee1db2675b94dcf7c6596f0c2fb0f57bef" => :yosemite
    sha256 "ebac309114f9866004cf2dee51af0f2ed0a513569e5928c065579937efd6526e" => :x86_64_linux
  end

  deprecated_option "with-check" => "with-test"
  option "with-test", "Run build-time tests"
  option "with-manpages", "Build man pages from XML docbook"
  option "with-static", "Build static instead of shared libraries"

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
      args << "-DGDCM_BUILD_SHARED_LIBS=ON" if build.without? "static"
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
