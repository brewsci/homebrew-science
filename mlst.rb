class Mlst < Formula
  desc "Multi-Locus Sequence Typing of microbial contigs"
  homepage "https://github.com/tseemann/mlst"
  # tag "bioinformatics"

  url "https://github.com/tseemann/mlst/archive/v2.6.tar.gz"
  sha256 "711bff24ce0873ab911cd43a17be3b805dd7bde7918f96401ce40e423f8de836"

  bottle do
    cellar :any_skip_relocation
    sha256 "72fc579a166cd813201a0a1561b80ba410943e652642be1e6b85b2cf1419735c" => :el_capitan
    sha256 "e07a445788221fb0339753b273e7ea89861e9708d93aec54233c034c3cf3841d" => :yosemite
    sha256 "2409d1b53557883751de173ddbe4d5c76441a2c61929a191d31b9c302af63001" => :mavericks
    sha256 "2f82fe0c58bc6827539923c576bb9e631f74975f912b272d21efdc173e6aa9ef" => :x86_64_linux
  end

  depends_on "blast"
  depends_on "Moo" => :perl
  depends_on "File::Temp" => :perl
  depends_on "File::Spec" => :perl
  depends_on "Data::Dumper" => :perl
  depends_on "List::MoreUtils" => :perl

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mlst --version")
    assert_match "senterica", shell_output("#{bin}/mlst --list 2>&1")
  end
end
