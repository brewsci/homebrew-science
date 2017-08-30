class Oce < Formula
  desc "Open CASCADE Community Edition"
  homepage "https://github.com/tpaviot/oce"
  url "https://github.com/tpaviot/oce/archive/OCE-0.18.2.tar.gz"
  sha256 "dc21ddea678a500ad87c773e9a502ed7a71768cf83d9af0bd4c43294186a7fef"

  bottle do
    sha256 "8fd1f46830b86e1c1483cc6583e59bdab76f4ba9c625ae0b9b31b6df1fd43a86" => :sierra
    sha256 "7fc9cd843d45bed31aea9b77822a0473b54430e4595e8c50e2b9f1140a1db02d" => :el_capitan
    sha256 "475c4ac1a5da8e0cdc9d1925fd51fd5c7e37bb2c3c5695786470dba500ace354" => :yosemite
  end

  option "without-opencl", "Build without OpenCL support"

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "ftgl"
  depends_on "freeimage" => :recommended
  depends_on "gl2ps" => :recommended
  depends_on "tbb" => :recommended

  if OS.mac?
    depends_on :xcode => :build
    depends_on :macos => :snow_leopard
  else
    depends_on "tcl-tk"
  end

  conflicts_with "opencascade", :because => "OCE is a fork for patches/improvements/experiments over OpenCascade"

  def install
    cmake_args = std_cmake_args
    cmake_args.delete("-DHAVE_CLOCK_GETTIME:INTERNAL=0")
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
      CASROOT=#{opt_share}/oce-#{version.to_s.split(".")[0..1].join(".")}
    EOF
  end

  test do
    vers = version.to_s.split(".")[0..1].join(".")
    cmd = "CASROOT=#{share}/oce-#{vers} #{bin}/DRAWEXE -v -c \"pload ALL\""
    assert_equal "1", shell_output(cmd).chomp
  end
end
