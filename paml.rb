class Paml < Formula
  homepage "http://abacus.gene.ucl.ac.uk/software/paml.html"
  url "http://abacus.gene.ucl.ac.uk/software/paml4.8a.tgz"
  sha256 "e45f37e1cfc1c24de276266a7bc2926fc12eac9602c56c1c025bc8f6dfb737f3"
  version "4.8a"

  bottle do
    cellar :any
    revision 2
    sha256 "37becefadba2dcd90bf6f9bdc7c100d5558e795cd3eb8d038c33bdf6bce366f9" => :yosemite
    sha256 "040cf5f030bf1b27b3ee20d0f2f1118e8bbfb54bdeb005296a0754b08f622ba8" => :mavericks
    sha256 "6ff2fb523b30c68704442cad420827dcb2035402cfcc36fae80f33347e605946" => :mountain_lion
  end

  def install
    cd "src" do
      system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
      bin.install %w[baseml basemlg chi2 codeml evolver infinitesites mcmctree pamp yn00]
    end

    (share/"paml").install "dat"
    (share/"paml").install Dir["*.ctl"]
    doc.install Dir["doc/*"]
    doc.install "examples"
  end

  def caveats
    <<-EOS.undent
      Documentation and examples:
        #{HOMEBREW_PREFIX}/share/doc/paml
      Dat and ctl files:
        #{HOMEBREW_PREFIX}/share/paml
    EOS
  end

  test do
    cp Dir[doc/"examples/DatingSoftBound/*"], testpath
    system "infinitesites"
  end
end
