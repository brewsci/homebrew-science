class Oce < Formula
  desc "Open CASCADE Community Edition"
  homepage "https://github.com/tpaviot/oce"
  url "https://github.com/tpaviot/oce/archive/OCE-0.17.2.tar.gz"
  sha256 "8d9995360cd531cbd4a7aa4ca5ed969f08ec7c7a37755e2f3d4ef832c1b2f56e"

  bottle do
    sha256 "73427f93d1bb2be3b1c40145e67e74efe0843867340397cf6b3604ab42c6f82c" => :el_capitan
    sha256 "1c3347d52fa7fe46f2bdf97adc79afcd3b926340abe697242bf271bc1af624b2" => :yosemite
    sha256 "c1bcb365bacefd1238d0ddc96382f5cae53180d3be698a6a09f5f654ac3e8a45" => :mavericks
  end

  option "without-opencl", "Build without OpenCL support"

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "ftgl"
  depends_on "freeimage" => :recommended
  depends_on "gl2ps" => :recommended
  depends_on "tbb" => :recommended
  depends_on macos: :snow_leopard

  conflicts_with "opencascade", because: "OCE is a fork for patches/improvements/experiments over OpenCascade"

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
    vers = version.to_s.split(".")[0..1].join(".")
    cmd = "CASROOT=#{share}/oce-#{vers} #{bin}/DRAWEXE -v -c \"pload ALL\""
    assert_equal "1", shell_output(cmd).chomp
  end
end
