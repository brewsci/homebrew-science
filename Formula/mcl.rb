class Mcl < Formula
  desc "Clustering algorithm for graphs"
  homepage "https://micans.org/mcl"
  url "https://micans.org/mcl/src/mcl-14-137.tar.gz"
  sha256 "b5786897a8a8ca119eb355a5630806a4da72ea84243dba85b19a86f14757b497"
  # doi "10.1093/nar/30.7.1575"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "96193e00265275f392d64742e6298a482832cd4a7848a9e4e4b18d8440d22075" => :el_capitan
    sha256 "7224fd6d488de1671a28b905a39a2a4451c02a53faff329940b7d9793c82d5bb" => :yosemite
    sha256 "dc43d7491e66496ff3358ed9fb5c057a0bd73e6d9e5227221f5b8842b17980fc" => :mavericks
    sha256 "f48c0b0d8b161c2915ff6be8aa3184890f1651418ced9a17cd8288fa74406b1d" => :x86_64_linux
  end

  def install
    bin.mkpath
    system "./configure",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--enable-blast"
    system "make", "install"
    inreplace bin/"mcxdeblast", "/usr/local/bin/perl -w", "/usr/bin/env perl\nuse warnings;"
    inreplace bin/"clxdo", "/usr/local/bin/perl", "perl"
  end

  test do
    system bin/"mcl", "--help"
  end
end
