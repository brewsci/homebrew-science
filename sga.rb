class Sga < Formula
  desc "de novo genome assembler based on the concept of string graphs"
  homepage "https://github.com/jts/sga"
  url "https://github.com/jts/sga/archive/v0.10.14.tar.gz"
  sha256 "763c011b302e1085048c93d917f081ea9348a8470e222dfd369064548e8b3994"
  head "https://github.com/jts/sga.git"
  # doi "10.1101/gr.126953.111"
  # tag "bioinformatics"

  bottle do
    sha256 "cf547a4f578ec440e9c61b8b880ad910403efa4146b134e3794186914b8307eb" => :el_capitan
    sha256 "b2655f7c854934997edc95bd38de8baa0387aa677322109e5aefbd0b4c47b994" => :yosemite
    sha256 "36320d846cb7957f21482ca9de6421d36475bd31cb075a4b6674feff73ef7dde" => :mavericks
    sha256 "eb4e8705abb3831c03cfcecd3750a59f8cd37421b397ff296c968d12357bf91c" => :x86_64_linux
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
