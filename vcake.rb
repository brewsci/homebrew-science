class Vcake < Formula
  homepage "http://vcake.sourceforge.net/"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btm451"

  url "https://downloads.sourceforge.net/project/vcake/vcake%20%28c%29/vcakec_2.0/vcakec_2.0.tar"
  sha256 "ce0a85b422d17b95b5520536ed98c90c0691463371a07fdbd0af753658fdf9c3"

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
