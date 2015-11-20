class Augustus < Formula
  desc "predict genes in eukaryotic genomic sequences"
  homepage "http://bioinf.uni-greifswald.de/augustus/"
  # doi "10.1093/nar/gkh379"
  # tag "bioinformatics"

  url "http://bioinf.uni-greifswald.de/augustus/binaries/old/augustus.3.0.1.tar.gz"
  mirror "https://science-annex.org/pub/augustus/augustus.3.0.1.tar.gz"
  sha256 "cf402fc1758715f6acf2823083c4ea41edaa9476371ae82d01900bad74064e7a"

  bottle do
    cellar :any
    sha256 "de3e868755c82d7e8e51a2fc2905b6c25706f7d9b9862ef14fadd674456777a5" => :yosemite
    sha256 "38dc89023a148892624c4e7359d424a0ce1a2f20a4ab3f960ddc05b870a32278" => :mavericks
    sha256 "d070713a12c97bbe7d975c7cbc0260bb5c315e9e23607fd3f63070fea1050c41" => :mountain_lion
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
