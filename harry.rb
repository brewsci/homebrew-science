class Harry < Formula
  desc "Tool for Measuring String Similarity"
  homepage "http://www.mlsec.org/harry"
  url "http://www.mlsec.org/harry/files/harry-0.4.2.tar.gz"
  sha256 "43315f616057cc1640dd87fc3d81453b97ce111683514ad99909d0033bcb578a"

  bottle do
    sha256 "b2cf1f666ea7047a2122befc756349172e452810e94ed1c79f52869b7e7b1b51" => :el_capitan
    sha256 "0c3380663f3ddc1c3f7eea3b0ad99069a57f10d72fed30f228e96c37f69c9215" => :yosemite
    sha256 "b89d04a14d0de576fe21fc7d3152eabdff6b80e3725626482d0dbe720bbf70b0" => :mavericks
  end

  head do
    url "https://github.com/rieck/harry.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-openmp", "Enable OpenMP multithreading"

  depends_on "pkg-config" => :build
  depends_on "libconfig"
  depends_on "libarchive" => :recommended

  needs :openmp if build.with? "openmp"

  def install
    ENV.delete("SDKROOT")
    system "./bootstrap" if build.head?
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}"]
    args << "--with-openmp" if build.with? "openmp"
    args << "--with-pthreads" if build.without? "openmp"
    args << "--with-libarchive" if build.with? "libarchive"
    system "./configure", *args
    system "make", "all"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"harry", doc/"data.txt", "-"
    system bin/"harry", "-m", "dist_hamming", doc/"data.txt", "-"
  end
end
