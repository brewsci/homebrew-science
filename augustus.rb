require "formula"

class Augustus < Formula
  homepage "http://bioinf.uni-greifswald.de/augustus/"
  #doi "10.1093/nar/gkh379"
  #tag "bioinformatics"

  url "http://bioinf.uni-greifswald.de/augustus/binaries/augustus.3.0.1.tar.gz"
  mirror "https://science-annex.org/pub/augustus/augustus.3.0.1.tar.gz"
  sha1 "19f40b3b834aba0386646d9cb8120caf3f0eb64e"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "4950105f9950e28ea862bc0c3158707ba2d41f31" => :yosemite
    sha1 "8200186f17826e50584c67cd58ed0bd0cf5db15f" => :mavericks
    sha1 "7a31858172f66f0f9d3ccfae8a3d76af34b620d3" => :mountain_lion
  end

  depends_on "boost" => :recommended # for gz support

  fails_with :clang do
    build 600
    cause "error: invalid operands to binary expression"
  end

  def install
    system "make"
    rm_r %w[include mysql++ src]
    libexec.install Dir["*"]
    bin.install_symlink "../libexec/bin/augustus"
  end

  def caveats; <<-EOS.undent
    Set the environment variable AUGUSTUS_CONFIG_PATH:
      export AUGUSTUS_CONFIG_PATH=#{opt_prefix}/libexec/config
    EOS
  end

  test do
    system "#{bin}/augustus", "--version"
  end
end
