class Simpleitk < Formula
  desc "SimpleITK is a simplified layer built on top of ITK"
  homepage "http://www.simpleitk.org"
  url "https://downloads.sourceforge.net/project/simpleitk/SimpleITK/0.9.0/Source/SimpleITK-0.9.0.tar.gz"
  sha256 "111454070e62f93f7b241604f8ba41488032a80d09a5a0e8a1803dfdeaa26bc7"
  head "https://github.com/SimpleITK/SimpleITK.git"

  bottle do
    cellar :any
    sha256 "c7f5d7bb096122f6577d921bc1813e502515bbea37497ebe63118e07e4f6b2d9" => :el_capitan
    sha256 "c19e07f4f02982eec7991afd2384c090cabaa87e5a49146b634221707cd0819d" => :yosemite
    sha256 "b09618f1801915dd6cdba0c25af6685c5ddbb7dc21c8ad11e178c4e9600ae5f8" => :mavericks
  end

  depends_on "cmake" => :build
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
    args = std_cmake_args + %W[
      -DBUILD_TESTING=OFF
      -DUSE_SYSTEM_SWIG=ON
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
    args << "-DPYTHON_LIBRARY='#{`python-config --prefix`.chomp}/lib/libpython2.7.dylib'"
    args << "-DPYTHON_INCLUDE_DIR='#{`python-config --prefix`.chomp}/include/python2.7'"

    # Superbuild does only work in an out-of-source build, create a new folder
    mkdir "sitk-build" do
      # The cmake Superbuild will take care of downloading and compiling important
      # dependencies to be able to build simpleitk
      system "cmake", "../SuperBuild/", *args
      system "make"

      ENV.prepend_create_path "PYTHONPATH", lib+"python2.7/site-packages"
      if build.head?
        system "python", "SimpleITK-build/Wrapping/Python/Packaging/setup.py", "install", "--prefix=#{prefix}", "--record=installed.txt", "--single-version-externally-managed"
      else
        system "python", "SimpleITK-build/Wrapping/PythonPackage/setup.py", "install", "--prefix=#{prefix}", "--record=installed.txt", "--single-version-externally-managed"
      end
    end
  end

  test do
    system "python", "-c", "import SimpleITK"
  end
end
