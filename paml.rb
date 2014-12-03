require "formula"

class Paml < Formula
  homepage "http://abacus.gene.ucl.ac.uk/software/paml.html"
  url "http://abacus.gene.ucl.ac.uk/software/paml4.8a.tgz"
  sha1 "6160f441577a2bb82afd793e7691c42bd5491376"
  version "4.8a"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "ce419b8e5908fde0054ab5869534fde7a4e346c1" => :yosemite
    sha1 "219f8dfb87f93093fad1ab8f28a04d6938f182cd" => :mavericks
    sha1 "37142a7141b15cf2af6871525cc5491ab42100f6" => :mountain_lion
  end

  def install
    cd "src" do
      system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
      bin.install %w[baseml basemlg codeml pamp evolver yn00 chi2]
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
end
