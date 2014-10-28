require "formula"

class Simpleitk < Formula
  homepage "http://www.simpleitk.org"
  url "https://downloads.sourceforge.net/project/simpleitk/SimpleITK/0.8.0/Source/SimpleITK-0.8.0.tar.gz"
  sha1 "7f62f397d0b85dfe52bf2fd66155e5b3cdc95af9"
  head "https://github.com/SimpleITK/SimpleITK.git"

  depends_on "cmake" => :build
  depends_on "insighttoolkit" => [:build, "with-review"]
  depends_on "swig" => :build
  depends_on :python
  depends_on :java => :optional
  depends_on "r" => :optional
  depends_on "lua" => :optional

  option "examples", "Compile and install various examples"
  option "with-csharp", "Compile for C sharp"
  option "with-java", "Compile for Java"
  option "with-ruby", "Compile for Ruby"
  option "with-tcl", "Compile for Tcl"

  def install
    # Define the .git folder as simpleitk relies on it at build.
    ENV["GIT_DIR"] = cached_download/".git" if build.head?

    args = std_cmake_args + %W[
      -DBUILD_TESTING=OFF
    ]
    args << "-DBUILD_EXAMPLES=" + ((build.include? "examples") ? "ON" : "OFF")
    args << "-DWRAP_CSHARP=" + ((build.with? "csharp") ? "ON" : "OFF")
    args << "-DWRAP_JAVA=" + ((build.with? "java") ? "ON" : "OFF")
    args << "-DWRAP_LUA=" + ((build.with? "lua") ? "ON" : "OFF")
    args << "-DWRAP_PYTHON=ON"
    args << "-DWRAP_R=" + ((build.with? "r") ? "ON" : "OFF")
    args << "-DWRAP_RUBY=" + ((build.with? "ruby") ? "ON" : "OFF")
    args << "-DWRAP_TCL=" + ((build.with? "tcl") ? "ON" : "OFF")

    # CMake picks up the system's python dylib, even if we have a brewed one.
    args << "-DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'"

    system "cmake", ".", *args
    system "make", "install"

    ENV.prepend_create_path "PYTHONPATH", lib+"python2.7/site-packages"
    system "python", "Wrapping/PythonPackage/setup.py", "install", "--prefix=#{prefix}", "--record=installed.txt", "--single-version-externally-managed"
  end

  test do
    system "python", "-c", "import SimpleITK"
  end
end
