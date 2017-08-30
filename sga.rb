class Sga < Formula
  desc "De novo genome assembler based on the concept of string graphs"
  homepage "https://github.com/jts/sga"
  url "https://github.com/jts/sga/archive/v0.10.15.tar.gz"
  sha256 "1b18996e6ec47985bc4889a8cbc3cd4dd3a8c7d385ae9f450bd474e36342558b"
  head "https://github.com/jts/sga.git"
  # doi "10.1101/gr.126953.111"
  # tag "bioinformatics"

  bottle do
    sha256 "6337cf4e83fad44a794ab27443cee7f20977898ee774c133a34aa629106197d4" => :sierra
    sha256 "abf45ed87ec57fdf7711c7d40f02f62c0a786941aeef073b9dbf4f6f26e3f113" => :el_capitan
    sha256 "ffe45f8727f1be0b613c35fe0673d0d292ea3f128b951e6bfadf1f6c56119cb9" => :yosemite
    sha256 "94d42b4690fd179606c930860dc5ecaf108314fd514eac9058be1a8937c27f42" => :x86_64_linux
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
