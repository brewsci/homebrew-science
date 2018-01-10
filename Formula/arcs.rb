class Arcs < Formula
  desc "Scaffold genome sequence assemblies using 10x Genomics data"
  homepage "https://github.com/bcgsc/arcs"
  url "https://github.com/bcgsc/arcs/archive/v1.0.1.tar.gz"
  sha256 "4dc5336e741abdd0197335a21fcdc578eb4251131caf86ca4fb191c125065bf4"
  head "https://github.com/bcgsc/arcs.git"
  # tag "bioinformatics"

  bottle do
    sha256 "5fc2a163b0cab7ee8b662fc9894320eb1ffe65480375588f9c46f6a6e32469fc" => :high_sierra
    sha256 "77faa701b7565e526c7f7d7c8cb9e8643433848daecabfe7c70be238c8211a77" => :sierra
    sha256 "b0b6e643c146d8738db6e01433ccaf9e17c463a68c70ea8867300b4e15f39362" => :el_capitan
    sha256 "745b88fb06d2d81ebd21ba44ecd1b5a05cc5d71758f1cfd5110ce798e6ec7c3d" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost" => :build
  depends_on "zlib" unless OS.mac?

  def install
    inreplace "autogen.sh", "automake -a", "automake -a --foreign"
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_include}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/arcs --help")
  end
end
