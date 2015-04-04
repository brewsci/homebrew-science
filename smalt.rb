class Smalt < Formula
  homepage "https://www.sanger.ac.uk/resources/software/smalt/"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/smalt/smalt-0.7.6.tar.gz"
  sha256 "89ccdfe471edba3577b43de9ebfdaedb5cd6e26b02bf4000c554253433796b31"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Hannes", shell_output("smalt version")
  end
end
