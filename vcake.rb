class Vcake < Formula
  homepage "https://vcake.sourceforge.io/"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btm451"

  url "https://downloads.sourceforge.net/project/vcake/vcake%20%28c%29/vcakec_2.0/vcakec_2.0.tar"
  sha256 "ce0a85b422d17b95b5520536ed98c90c0691463371a07fdbd0af753658fdf9c3"

  bottle do
    cellar :any
    sha256 "e3de093b83befbb9ba2e479bc789d15bfbd493f94c826ba92c5207e2c7fc9718" => :yosemite
    sha256 "9ee7af972691069240da61d5ef742138ba65b6cc880729b579bf42ed5eb4a376" => :mavericks
    sha256 "759130c98062cbc51fd3f0f66b98871da9d738e2a4655e1c0b72b7f2b17312ea" => :mountain_lion
    sha256 "38509ad357eb8e69726cbf62dc2f77e52d20ec35443f006a653dcf098dabf598" => :x86_64_linux
  end

  def install
    inreplace "src/Makefile", " -Werror", ""
    system "make"
    bin.install "src/vcake"
    doc.install "README"
  end

  test do
    assert_match "holding", shell_output("vcake 2>&1", 1)
  end
end
