class Vcflib < Formula
  desc "Command-line tools for manipulating VCF files"
  homepage "https://github.com/ekg/vcflib"
  # tag "bioinformatics"

  url "https://github.com/ekg/vcflib.git",
    :revision => "b1e9b31d2d95f957f86cdfd1e7c9ec25b4950ee8"
  version "20150314"

  head "https://github.com/ekg/vcflib.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "3c18a240c6771826d350589bead3a31642edd6b4d87d0fbbd2dd7e56f7a75730" => :yosemite
    sha256 "d3d3747651f85477a39a60f09e1394ec9cec7ea3cb24625b355f4345d9be0791" => :mavericks
    sha256 "4ba328be1a131b4f591c0debb839e82ac0da9f6b101ee16dc8f17141492577e9" => :mountain_lion
  end

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
