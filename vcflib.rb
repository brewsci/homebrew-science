class Vcflib < Formula
  desc "Command-line tools for manipulating VCF files"
  homepage "https://github.com/ekg/vcflib"
  # tag "bioinformatics"

  url "https://github.com/ekg/vcflib.git",
    :revision => "8ac9fd517579134ef3b9797714d20c9c99c18ec6"
  version "20150603"

  head "https://github.com/ekg/vcflib.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "d9453aa105682ac17539efd11983b2d7018327cf58a6c19807613a8f0b2d959b" => :yosemite
    sha256 "aaebf992cb9fe3a63e4551126f99d2a44ff17e3321a787fdac5de5cc8d5db41f" => :mavericks
    sha256 "1ab06e308fd9787b81408193b389fb63e9f53a838750f89eeeae3efbad6244a3" => :mountain_lion
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
