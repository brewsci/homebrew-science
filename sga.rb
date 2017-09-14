class Sga < Formula
  desc "De novo genome assembler based on the concept of string graphs"
  homepage "https://github.com/jts/sga"
  url "https://github.com/jts/sga/archive/v0.10.15.tar.gz"
  sha256 "1b18996e6ec47985bc4889a8cbc3cd4dd3a8c7d385ae9f450bd474e36342558b"
  head "https://github.com/jts/sga.git"
  # doi "10.1101/gr.126953.111"
  # tag "bioinformatics"

  bottle do
    sha256 "6d04064faf78bb77d302783b3977e57d28f8d16d524b42660b2b85fe9363d43b" => :sierra
    sha256 "ff5ee31db095e42df84c8701afaf4adc95adbdf4efb259c8d9207d1518e0f398" => :el_capitan
    sha256 "eccaea15d67467f0fce69cdbf83771af215be8c2a8903a93f4e43eb7c0bf63d5" => :yosemite
    sha256 "d816e1738680e02afa84882f4658af82735f79134529690b66cbb9e2eff17c46" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "google-sparsehash" => :build
  depends_on "bamtools"

  def install
    cd "src" do
      system "./autogen.sh"
      system "./configure", "--disable-dependency-tracking",
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
