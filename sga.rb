class Sga < Formula
  desc "de novo genome assembler based on the concept of string graphs"
  homepage "https://github.com/jts/sga"
  url "https://github.com/jts/sga/archive/v0.10.14.tar.gz"
  sha256 "763c011b302e1085048c93d917f081ea9348a8470e222dfd369064548e8b3994"
  head "https://github.com/jts/sga.git"
  # doi "10.1101/gr.126953.111"
  # tag "bioinformatics"

  bottle do
    sha256 "38ab130fa407f25949bb97dea6b680c8c6d00ab637980ef807b5a9778a929c72" => :el_capitan
    sha256 "29f7b08aff833f553023e74ef2cb3778d9aa11695fc7ea8941444a46dcfae81c" => :yosemite
    sha256 "11d3ed6416542c4133325ec132f015fcfe7a7f62a78869ec50c5e19a51f58ad8" => :mavericks
    sha256 "91872ec5199913bc343ab91d56c760765d1a636696f359bdf5ca5b1b9cd71e70" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "google-sparsehash" => :build
  depends_on "bamtools"

  # Fix error: use of undeclared identifier 'omp_set_num_threads'
  patch do
    url "https://github.com/jts/sga/commit/e0ffbff4eb8a2c8fa53d55da1043c981d5b3813a.patch"
    sha256 "8087e4c40d0f57ae10c544de4b738e50f16cc3f8c33aa4ed69034e79e278af69"
  end

  def install
    cd "src" do
      system "./autogen.sh"
      system "./configure",
        "--disable-dependency-tracking",
        "--prefix=#{prefix}",
        "--with-bamtools=#{Formula["bamtools"].prefix}",
        "--with-sparsehash=#{Formula["google-sparsehash"].prefix}"
      system "make", "install"
      bin.install Dir["bin/*"] - Dir["bin/Makefile*"]
    end
  end

  test do
    system "#{bin}/sga", "--version"
  end
end
