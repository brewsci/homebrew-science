class Centrifuge < Formula
  desc "Rapid sensitive classification of metagenomic sequences"
  homepage "http://www.ccb.jhu.edu/software/centrifuge"
  url "https://github.com/infphilo/centrifuge/archive/f39767eb57d8e175029c.tar.gz"
  version "1.0.3-beta"
  sha256 "9561f0b106f66e966b10e5add1ffe4507eb02a65a69741e07b0f6f24a240ccea"
  head "https://github.com/infphilo/centrifuge"
  bottle do
    cellar :any
    sha256 "0b69a0571a51bddf3de99a5c857c4852ab61fcaede4be4bca70fe58455c04403" => :sierra
    sha256 "1da9c688f9f1feb05deb7a8617b633c73869c3d32befaba4636af3b6984c57da" => :el_capitan
    sha256 "67b8a286a21f829914255d5ce7ad3f36d98471e4751f5951211ae3c89fc886ec" => :yosemite
    sha256 "049d0280cc9a694280433e0f3d358e326c264f12508f0d7dbd64cc93e3c34176" => :x86_64_linux
  end

  # doi "10.1101/054965"
  # tag "bioinformatics"

  needs :openmp

  def install
    system "make"
    bin.install "centrifuge", Dir["centrifuge-*"]
    pkgshare.install "example", "indices", "evaluation"
    doc.install "doc", "MANUAL", "TUTORIAL"
  end

  def caveats
    <<-EOS.undent
      The Makefile for building indices was installed to:
        #{pkgshare}/indices
    EOS
  end

  test do
    assert_match "deterministic", shell_output("#{bin}/centrifuge --help 2>&1")
  end
end
