class Simpleitk < Formula
  desc "Simplified layer built on top of ITK"
  homepage "http://www.simpleitk.org"
  url "https://downloads.sourceforge.net/project/simpleitk/SimpleITK/0.10.0/Source/SimpleITK-0.10.0-1.tar.gz"
  sha256 "e849d693d67622b0dcb1153124e38ece9256b7c4760e35fa3af3cd90b851662f"
  head "https://github.com/SimpleITK/SimpleITK.git"

  bottle do
    cellar :any
    sha256 "c7f5d7bb096122f6577d921bc1813e502515bbea37497ebe63118e07e4f6b2d9" => :el_capitan
    sha256 "c19e07f4f02982eec7991afd2384c090cabaa87e5a49146b634221707cd0819d" => :yosemite
    sha256 "b09618f1801915dd6cdba0c25af6685c5ddbb7dc21c8ad11e178c4e9600ae5f8" => :mavericks
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
    ENV.delete("PYTHONPATH")

    args = std_cmake_args + %w[
      -DBUILD_TESTING=OFF
      -DUSE_SYSTEM_SWIG=ON
    ]
    args << "-DBUILD_EXAMPLES=" + ((build.include? "examples") ? "ON" : "OFF")
    args << "-DWRAP_PYTHON=ON"
    args << "-DWRAP_CSHARP=" + ((build.with? "csharp") ? "ON" : "OFF")
    args << "-DWRAP_JAVA=" + ((build.with? "java") ? "ON" : "OFF")
    args << "-DWRAP_LUA=" + ((build.with? "lua") ? "ON" : "OFF")
    args << "-DWRAP_R=" + ((build.with? "r") ? "ON" : "OFF")
    args << "-DWRAP_RUBY=" + ((build.with? "ruby") ? "ON" : "OFF")
    args << "-DWRAP_TCL=" + ((build.with? "tcl") ? "ON" : "OFF")

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
