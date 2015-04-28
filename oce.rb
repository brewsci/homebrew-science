class Oce < Formula
  homepage "https://github.com/tpaviot/oce"
  url "https://github.com/tpaviot/oce/archive/OCE-0.17.tar.gz"
  sha256 "9ab0dc2a2d125b46cef458b56c6d171dfe2218d825860d616c5ab17994b8f74d"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "75932d64aab68b7fad6c27a365cee5158924d311f9fbe789c063379b87759a2d" => :yosemite
    sha256 "b98386e67112e79bfecb597f61fd00e86d8c2ed0b51fa07bdf5d3b105b34d9e0" => :mavericks
    sha256 "c7e01db93d10a1bcccb7f52419caaec057eeb5cf246f25f7ca2514533b1d83eb" => :mountain_lion
  end

  conflicts_with "opencascade", :because => "OCE is a fork for patches/improvements/experiments over OpenCascade"

  option "without-opencl", "Build without OpenCL support"

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "ftgl"
  depends_on "freeimage" => :recommended
  depends_on "gl2ps" => :recommended
  depends_on "tbb" => :recommended
  depends_on :macos => :snow_leopard

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DOCE_INSTALL_PREFIX:STRING=#{prefix}"
    cmake_args << "-DOCE_COPY_HEADERS_BUILD:BOOL=ON"
    cmake_args << "-DOCE_DRAW:BOOL=ON"
    cmake_args << "-DOCE_MULTITHREAD_LIBRARY:STRING=TBB" if build.with? "tbb"
    cmake_args << "-DFREETYPE_INCLUDE_DIRS=#{Formula["freetype"].opt_include}/freetype2"

    %w[freeimage gl2ps].each do |feature|
      cmake_args << "-DOCE_WITH_#{feature.upcase}:BOOL=ON" if build.with? feature
    end

    opencl_path = Pathname.new "/System/Library/Frameworks/OpenCL.framework"
    if build.with?("opencl") && opencl_path.exist?
      cmake_args << "-DOCE_WITH_OPENCL:BOOL=ON"
      cmake_args << "-DOPENCL_LIBRARIES:PATH=#{opencl_path}"
      cmake_args << "-D_OPENCL_CPP_INCLUDE_DIRS:PATH=#{opencl_path}/Headers"
    end

    system "cmake", ".", *cmake_args
    system "make", "install/strip"
  end

  def caveats; <<-EOF.undent
    Some apps will require this enviroment variable:
      CASROOT=#{opt_share}/oce-#{version}
    EOF
  end

  test do
    "1\n"==`CASROOT=#{share}/oce-#{version} #{bin}/DRAWEXE -v -c \"pload ALL\"`
  end
end
