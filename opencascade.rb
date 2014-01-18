require "formula"

class Opencascade < Formula
  homepage "http://www.opencascade.org/"
  url "http://files.opencascade.com/OCCT/OCC_6.7.0_release/opencascade-6.7.0.tgz"
  sha1 "5c22457c327b90d0256f6adefaee3853e0b0e251"

  conflicts_with "oce", :because => "OCE is a fork for patches/improvements/experiments over OpenCascade"

  option "without-opencl", "Build without OpenCL support"
  option "without-extras", "Don't install documentation (~725MB) or samples (~40MB)"
  option "with-tests", "Install tests (~55MB)"

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "qt"
  depends_on "freeimage" => :recommended
  depends_on "gl2ps" => :recommended
  depends_on "tbb" => :recommended
  depends_on :macos => :snow_leopard

  def install

    # setting DYLD causes many issues; all tests work fine without; suppress
    inreplace "env.sh", "export DYLD_LIBRARY_PATH", "export OCCT_DYLD_LIBRARY_PATH"

    cmake_args = std_cmake_args
    cmake_args << "-DCMAKE_PREFIX_PATH:PATH=#{HOMEBREW_PREFIX}"
    cmake_args << "-DCMAKE_INCLUDE_PATH:PATH=#{HOMEBREW_PREFIX}/lib"
    cmake_args << "-DCMAKE_FRAMEWORK_PATH:PATH=#{HOMEBREW_PREFIX}/Frameworks"
    cmake_args << "-DINSTALL_DIR:PATH=#{prefix}"
    cmake_args << "-D3RDPARTY_DIR:PATH=#{HOMEBREW_PREFIX}"
    cmake_args << "-D3RDPARTY_TCL_DIR:PATH=/usr"
    cmake_args << "-DINSTALL_TESTS:BOOL=ON" if build.with? "tests"
    cmake_args << "-D3RDPARTY_TBB_DIR:PATH=#{HOMEBREW_PREFIX}" if build.with? "tbb"

    # must specify, otherwise finds old ft2config.h in /usr/X11R6
    cmake_args << "-D3RDPARTY_FREETYPE_INCLUDE_DIR:PATH=#{HOMEBREW_PREFIX}/include"

    %w{freeimage gl2ps opencl tbb}.each do |feature|
      cmake_args << "-DUSE_#{feature.upcase}:BOOL=ON" if build.with? feature
    end

    opencl_path = Pathname.new "/System/Library/Frameworks/OpenCL.framework/Versions/Current"
    if build.with?("opencl") && opencl_path.exist?
      cmake_args << "-D3RDPARTY_OPENCL_INCLUDE_DIR:PATH=#{opencl_path}/Headers"
      cmake_args << "-D3RDPARTY_OPENCL_DLL:FILEPATH=#{opencl_path}/Libraries/libcl2module.dylib"

      # link against the Apple built-in OpenCL Framework
      inreplace "adm/cmake/TKOpenGL/CMakeLists.txt", "list( APPEND TKOpenGl_USED_LIBS OpenCL )", <<-EOF.undent
        find_library(FRAMEWORKS_OPENCL NAMES OpenCL)
        list( APPEND TKOpenGl_USED_LIBS ${FRAMEWORKS_OPENCL} )
      EOF
    end

    system "cmake", ".", *cmake_args
    system "make", "install"

    prefix.install "doc", "samples" if build.with? "extras"
  end

  def caveats; <<-EOF.undent
    Some apps will require this enviroment variable:
      CASROOT=#{opt_prefix}
    EOF
  end

  test do
    ENV["CASROOT"] = opt_prefix
    "1\n"==`#{bin}/DRAWEXE -c \"pload ALL\"`
  end
end
