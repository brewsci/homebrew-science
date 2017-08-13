class CIRequirement < Requirement
  # simpleitk hits the 4 Gb memory limit of circle,
  # even with -j1
  fatal true
  satisfy { ENV["CIRCLECI"].nil? && ENV["TRAVIS"].nil? }
end

class Simpleitk < Formula
  desc "Simplified layer built on top of ITK"
  homepage "http://www.simpleitk.org"
  url "https://downloads.sourceforge.net/project/simpleitk/SimpleITK/1.0.0/Source/SimpleITK-1.0.0.tar.gz"
  sha256 "e3988e8b9db28615faecdecb3e703f54ef67a20be3391d91869f84713f90a414"
  version_scheme 1
  head "https://github.com/SimpleITK/SimpleITK.git"

  bottle do
    sha256 "a1fe57a2916ee47ae3b98016155790f915138eb2cb78ff7e95e8bdf9b1a225b3" => :sierra
    sha256 "d22b71717c8c1a45d2f823ef3f82b1ee22be13019d14db4f3bbce9fe68b8717b" => :el_capitan
    sha256 "234ad328cdeecfcfefe41fee3ddbc89334d10a690b484f1950b64a04c23c0b76" => :yosemite
    sha256 "e4dba27408e1427ed0ce18224eca2fe8026a1b56fec065f242d008a89fa4dadb" => :x86_64_linux
  end

  option "with-examples", "Compile and install various examples"
  option "with-csharp", "Compile for C sharp"
  option "with-ruby", "Compile for Ruby"
  option "with-tcl", "Compile for Tcl"

  deprecated_option "examples" => "with-examples"

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on :python => :recommended
  depends_on :python3 => :optional
  depends_on :java => :optional
  depends_on "r" => :optional
  depends_on "lua" => :optional
  depends_on CIRequirement unless OS.mac?

  def install
    ENV.delete("PYTHONPATH")

    # Remove the CMAKE_INSTALL_PREFIX. The SuperBuild used here will install
    # a bunch of files which we are not interested in. This reduces the binaries
    # siwe. We only need the output of the setupegg.py call at the end
    # of the installation.
    args = std_cmake_args.delete_if { |x| x.include?("CMAKE_INSTALL_PREFIX") }

    args += %w[
      -DBUILD_TESTING=OFF
      -DSimpleITK_USE_SYSTEM_SWIG=ON
      -DSimpleITK_EXPLICIT_INSTANTIATION=OFF
    ]
    args << "-DSWIG_EXECUTABLE=#{Formula["swig"].opt_bin}/swig" unless OS.mac?
    args << "-DBUILD_EXAMPLES=" + (build.include?("examples") ? "ON" : "OFF")
    args << "-DWRAP_PYTHON=ON"
    args << "-DWRAP_CSHARP=" + (build.with?("csharp") ? "ON" : "OFF")
    args << "-DWRAP_JAVA=" + (build.with?("java") ? "ON" : "OFF")
    args << "-DWRAP_LUA=" + (build.with?("lua") ? "ON" : "OFF")
    args << "-DWRAP_R=" + (build.with?("r") ? "ON" : "OFF")
    args << "-DWRAP_RUBY=" + (build.with?("ruby") ? "ON" : "OFF")
    args << "-DWRAP_TCL=" + (build.with?("tcl") ? "ON" : "OFF")

    # Superbuild does only work in an out-of-source build, create a new folder
    mkdir "sitk-build" do
      python_executable = `which python`.strip
      python_executable = `which python3`.strip if build.with? "python3"

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

      py_site_packages = "#{lib}/#{python_version}/site-packages"
      ENV.prepend_create_path "PYTHONPATH", py_site_packages

      # The cmake Superbuild will take care of downloading and compiling important
      # dependencies to be able to build simpleitk
      system "cmake", "../SuperBuild/", *args
      system "make"

      system python_executable, "SimpleITK-build/Wrapping/Python/Packaging/setupegg.py", "install", "--prefix=#{prefix}", "--record=installed.txt", "--single-version-externally-managed"
    end
  end

  test do
    system "python", "-c", "import SimpleITK"
  end
end
