class Sga < Formula
  homepage "https://github.com/jts/sga"
  # doi '10.1101/gr.126953.111'
  url "https://github.com/jts/sga/archive/v0.10.13.tar.gz"
  sha256 "77859ab233980594941aa4c4cb5c2cbe1f5c43f2519f329c3a88a97865dee599"
  head "https://github.com/jts/sga.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  # Only header files are used, so :build is appropriate
  depends_on "google-sparsehash" => :build
  depends_on "bamtools"

  def install
    cd "src" do
      system "./autogen.sh"
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-bamtools=#{Formula["bamtools"].opt_prefix}",
                            "--with-sparsehash=#{Formula["google-sparsehash"].opt_prefix}"
      system "make", "install"
      bin.install Dir["bin/*"] - Dir["bin/Makefile*"]
    end
  end

  test do
    system "#{bin}/sga", "--version"
  end
end
