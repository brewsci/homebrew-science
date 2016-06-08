class Vcflib < Formula
  desc "Command-line tools for manipulating VCF files"
  homepage "https://github.com/ekg/vcflib"
  # tag "bioinformatics"

  url "https://github.com/ekg/vcflib.git",
    :tag => "v1.0.0-rc0", :revision => "8ac9fd517579134ef3b9797714d20c9c99c18ec6"
  head "https://github.com/ekg/vcflib.git"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "f7f3700673941a4db264a125a0b3e49dec3ec669039a0973fc93cd55954f9e24" => :el_capitan
    sha256 "92ade1c0f98fe701075ea9841cf74b7baef020e0a41f65b1bc063066104c2ffd" => :yosemite
    sha256 "52c6168b3a1ad58652ef6fd20af6fd9f8e07376226fa3bcd126fc4e8922ab7b7" => :mavericks
    sha256 "551fde77c9fa2a8cf60ccab767edf48893bfe353313446ff819609a777a3eed4" => :x86_64_linux
  end

  def install
    if OS.mac?
      # FIX => missing makefile var: https://github.com/ekg/tabixpp/issues/5
      inreplace "tabixpp/Makefile", "SUBDIRS=.", "SUBDIRS=.\nLOBJS=tabix.o"
      # FIX => ld: internal error: atom not found in symbolIndex(<snip>) for architecture x86_64
      inreplace "smithwaterman/Makefile", "LDFLAGS=-Wl,-s", "LDFLAGS="
    end

    system "make"

    bin.install Dir["bin/*"]
    doc.install %w[LICENSE README.md]
  end

  test do
    assert_match "genotype", shell_output("vcfallelicprimitives -h 2>&1", 0)
  end
end
