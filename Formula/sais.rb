class Sais < Formula
  homepage "https://sites.google.com/site/yuta256/"
  url "https://sites.google.com/site/yuta256/sais-2.4.1.zip"
  sha256 "467b7b0b6ec025535c25e72174d3cc7e29795643e19a3f8a18af9ff28eca034a"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "pkg-config --modversion libsais"
  end
end
