class Mlst < Formula
  desc "Multi-Locus Sequence Typing of microbial contigs"
  homepage "https://github.com/tseemann/mlst"
  # tag "bioinformatics"

  url "https://github.com/tseemann/mlst/archive/2.4.tar.gz"
  sha256 "6263e124bbc5f481d94dddaf4906fef05babdd9fe6e8b30de8ffbf9bdb0dfb1d"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d74d46e7a467d9aafe94a2ae33c05eee7dec985841b99e101fa0c60bc10788c" => :el_capitan
    sha256 "b36e0c426f6583f5649620a4f0f4d5a6a0dd84f3dd50c3978d09e9e2e33d0207" => :yosemite
    sha256 "ab387db5c198bc9ed6cea2b3bbcccdda40bdf9dbc8d8f2d18f6947bf0ff7ca67" => :mavericks
    sha256 "50716cb3a2e7e7d6cfaef9148271c06e35c8ce25578fbe6174dccba95edac964" => :x86_64_linux
  end

  depends_on "blast"
  depends_on "Moo" => :perl
  depends_on "File::Temp" => :perl
  depends_on "File::Spec" => :perl
  depends_on "Data::Dumper" => :perl
  depends_on "List::MoreUtils" => :perl

  def install
    # if version is bumped before tag next time, this can be removed.
    inreplace "bin/mlst", "my $VERSION = \"2.3\"", "my $VERSION = \"2.4\""
    prefix.install Dir["*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mlst --version")
    assert_match "senterica", shell_output("#{bin}/mlst --list 2>&1")
  end
end
