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
    sha256 "3c18a240c6771826d350589bead3a31642edd6b4d87d0fbbd2dd7e56f7a75730" => :yosemite
    sha256 "d3d3747651f85477a39a60f09e1394ec9cec7ea3cb24625b355f4345d9be0791" => :mavericks
    sha256 "4ba328be1a131b4f591c0debb839e82ac0da9f6b101ee16dc8f17141492577e9" => :mountain_lion
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
