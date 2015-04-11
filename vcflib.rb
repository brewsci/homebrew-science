class Vcflib < Formula
  desc "Command-line tools for manipulating VCF files"
  homepage "https://github.com/ekg/vcflib"
  # tag "bioinformatics"

  url "https://github.com/ekg/vcflib.git",
    :revision => "b1e9b31d2d95f957f86cdfd1e7c9ec25b4950ee8"
  version "20150314"

  head "https://github.com/ekg/vcflib.git"

  # Fix /usr/bin hashbang: https://github.com/ekg/vcflib/pull/84
  patch do
    url "https://patch-diff.githubusercontent.com/raw/ekg/vcflib/pull/84.diff"
    sha256 "e4ad6d11b864c47834be5eed67edeb6d6bb52ed83bbb0f93683def3fa1735458"
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
