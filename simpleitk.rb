class Simpleitk < Formula
  desc "Simplified layer built on top of ITK"
  homepage "http://www.simpleitk.org"
  url "https://downloads.sourceforge.net/project/simpleitk/SimpleITK/1.0.0/Source/SimpleITK-1.0.0.tar.gz"
  sha256 "e3988e8b9db28615faecdecb3e703f54ef67a20be3391d91869f84713f90a414"
  version_scheme 1
  head "https://github.com/SimpleITK/SimpleITK.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a0401e5e1710c25a8b372b8bbe631611343e9b2246027e9a3f2f799e33bd4b9" => :sierra
    sha256 "9f3c22351ab13987092c40904c6a606775334413e5f0bb7a5d173bb8bfa4177b" => :el_capitan
    sha256 "ec9626b51cdf6962d18dafbf3dff2ced29c385bb5c9205b77677915e2e4d241f" => :yosemite
    sha256 "e9402d73261eb385c4f7ba24269c72ea989f997a74236378fc9040f8555d4330" => :x86_64_linux
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

  def install
    # Reduce memory usage below 4 GB for Linux CI
    ENV["MAKEFLAGS"] = "-j1" if OS.linux? && build.bottle?

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
