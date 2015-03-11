require "formula"

class Paml < Formula
  homepage "http://abacus.gene.ucl.ac.uk/software/paml.html"
  url "http://abacus.gene.ucl.ac.uk/software/paml4.8a.tgz"
  sha256 "e45f37e1cfc1c24de276266a7bc2926fc12eac9602c56c1c025bc8f6dfb737f3"
  version "4.8a"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    revision 1
    sha256 "578a692dadffed72b1845b1e64ba9e1561ff7fcc79c986c4c2e9e9731ad2e69e" => :yosemite
    sha256 "a56081655e0a7e59e6266c385d1a7ad7183b0223da698c660a64be66627a71f9" => :mavericks
    sha256 "b50727426a1324fb3e945e19e1453a9587355e4961d74c2ef04f9f18c3470233" => :mountain_lion
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
