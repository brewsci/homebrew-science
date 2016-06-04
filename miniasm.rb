class Miniasm < Formula
  desc "Ultrafast de novo assembly for long noisy reads"
  homepage "https://github.com/lh3/miniasm"
  bottle do
    cellar :any_skip_relocation
    sha256 "68b11d329ba971d1afac15f3bdf47c9021da0bec9c21b0d1f2dd5ec8618f9e14" => :el_capitan
    sha256 "911b8b5a12ce00126d6a6d44b09871ff7f3d85a5f8da363a4b6c6511fe0f0a4e" => :yosemite
    sha256 "84365136802af859acbd979866e9786cfa5c1064c2e223cf77ee9cd693187e56" => :mavericks
    sha256 "be12b732a1065539f490bf1690590cdaf02bfbd46d372fb6bc0e5d56f8850977" => :x86_64_linux
  end

  # tag "bioinformatics"

  url "https://github.com/lh3/miniasm/archive/v0.2.tar.gz"
  sha256 "177cbb93dbdd3da73e3137296f7822ede830af10339aa7f84fc76afab95a1be6"

  head "https://github.com/lh3/miniasm.git"

  depends_on "minimap"

  def install
    system "make"
    bin.install "miniasm", "minidot"
    pkgshare.install "misc"
  end

  test do
    assert_match "in.paf", shell_output("#{bin}/miniasm 2>&1", 1)
  end
end
