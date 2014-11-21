require "formula"

class Nexusformat < Formula
  homepage "http://www.nexusformat.org"
  url "https://github.com/nexusformat/code/archive/4.3.3.tar.gz"
  sha1 "89f1e7ec5706868f9a488a44aeb2305587ab5180"

  option :cxx11

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libmxml"
  depends_on "readline" => :recommended
  depends_on "hdf5" => (build.cxx11? ? "c++11" : :build)
  depends_on "homebrew/versions/hdf4" => :recommended
  depends_on "doxygen" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --disable-dependency-tracking
      --disable-debug
      --with-hdf4=#{Formula["homebrew/versions/hdf4"].opt_prefix}
    ]
    system "/bin/sh", "autogen.sh"
    ENV.cxx11 if build.cxx11?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/nxdir"
  end
end
