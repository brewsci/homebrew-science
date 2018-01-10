class Harry < Formula
  desc "Tool for Measuring String Similarity"
  homepage "http://www.mlsec.org/harry"
  url "http://www.mlsec.org/harry/files/harry-0.4.2.tar.gz"
  sha256 "43315f616057cc1640dd87fc3d81453b97ce111683514ad99909d0033bcb578a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "057ad501768616bf27dde8e542bc1105e94570f7bf8cb60c0bd433a611d59efe" => :sierra
    sha256 "85bf33c44fdf156cfb097f39da759412c7261d482e568b32ff90f351dc8aa1e9" => :el_capitan
    sha256 "a7d5942f0c3ecd0b2b4918e0c710f285cf5558843e0c9aff06a46aeae0b744f3" => :yosemite
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
