require "formula"

class Oce < Formula
  homepage "https://github.com/tpaviot/oce"
  url "https://github.com/tpaviot/oce/archive/OCE-0.15.tar.gz"
  sha1 "3036ca47202bdffdef79a65c314a446424ac47f1"

  conflicts_with "opencascade", :because => "OCE is a fork for patches/improvements/experiments over OpenCascade"

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "ftgl"
  depends_on "freeimage" => :recommended
  depends_on "gl2ps" => :recommended
  depends_on "tbb" => :recommended
  depends_on :x11 => :recommended
  depends_on :macos => :snow_leopard

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DOCE_INSTALL_PREFIX:STRING=#{prefix}"
    cmake_args << "-DOCE_COPY_HEADERS_BUILD:BOOL=ON"
    cmake_args << "-DOCE_DRAW:BOOL=ON"
    cmake_args << "-DOCE_MULTITHREAD_LIBRARY:STRING=TBB" if build.with? "tbb"
    cmake_args << "-DOCE_DISABLE_X11:BOOL=ON" if build.without? "x11"

    %w{freeimage gl2ps}.each do |feature|
      cmake_args << "-DOCE_WITH_#{feature.upcase}:BOOL=ON" if build.with? feature
    end

    system "cmake", ".", *cmake_args
    system "make", "install/strip"
  end

  test do
    "1\n"==`#{bin}/DRAWEXE -c \"pload ALL\"`
  end
end
