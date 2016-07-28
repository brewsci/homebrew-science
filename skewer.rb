class Skewer < Formula
  desc "Fast and accurate NGS adapter trimmer"
  homepage "https://github.com/relipmoc/skewer"
  url "https://github.com/relipmoc/skewer/archive/0.1.126.tar.gz"
  sha256 "3430fdddcdbea0f5c852b330f99f8773b57f9053bc3ace9f89367e836c2a1332"
  head "https://github.com/relipmoc/skewer.git"
  # doi "10.1186/1471-2105-15-182"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d7c6e923b77aa9afb8c1334fa531dc34ecb77a00ebd5a0b7c0a5f499c1ddaf2" => :el_capitan
    sha256 "a1396d4d7a617f8abd23b08e1d8ac0d9a995fa1872a556a6dff184513020a4dc" => :yosemite
    sha256 "4f7f544bb0ec00a4ab303a4022cfa1c454034bc5b2be7f5613e3cc553e69d596" => :mavericks
    sha256 "3d7443bd5e0356d3d1ec6e3185f818e5cedd3cf0d2e3e2444e16e1c22326f269" => :x86_64_linux
  end

  def install
    system "make", "CXXFLAGS=-O2 -c"
    bin.install "skewer"
    doc.install "README.md", "LICENSE"
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/skewer --help 2>&1", 1)
  end
end
