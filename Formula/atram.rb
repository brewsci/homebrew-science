class Atram < Formula
  desc "Automated target restricted assembly method"
  homepage "https://github.com/juliema/aTRAM"

  # doi "10.5281/zenodo.10431"
  # tag "bioinformatics"

  url "https://github.com/juliema/aTRAM/archive/v1.3.0.tar.gz"
  sha256 "b4ab5f2ceec7cf1566585cf772b34e5efee25f9368b8e307698edc37f72a11f9"
  version_scheme 1
  head "https://github.com/juliema/aTRAM.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0828d9e44444fdfd26f1b209c956cf130c9ba44915cfb4285a73f24c14804e0f" => :high_sierra
    sha256 "3d4d87141fe67eb040f5abf3a25b9a8f88d134f40ab50ae329985a7ed574dae8" => :sierra
    sha256 "5a957652fd330d42f1db80f5caeecebe18913473cfd8c45bd28de45fcbbf7fe0" => :el_capitan
    sha256 "06a242ab83c7ce5d5eb5412da5de2c3deeffa4ae214b5802de9039dc65c4d2e3" => :x86_64_linux
  end

  depends_on "blast"
  depends_on "mafft"
  depends_on "muscle"
  depends_on "trinity"
  depends_on "velvet"

  def install
    prefix.install Dir["*"]
    cd prefix
    system "perl", prefix/"configure.pl", "-no"
  end

  test do
    assert_match /No shards to be made/, shell_output("perl #{prefix}/test/test_format_sra.pl -input #{prefix}/test/test_sra.fasta")
  end
end
