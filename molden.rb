class Molden < Formula
  desc "Pre- and post-processing of molecular and electronic structure"
  homepage "http://www.cmbi.ru.nl/molden/"
  url "ftp://ftp.cmbi.ru.nl/pub/molgraph/molden/molden5.7.tar.gz"
  sha256 "8c52229f1762e987995c53936f0dc2cfd086277ec777bf9083d76c0bf0483887"

  depends_on :x11
  depends_on :fortran

  def install
    system "make"
    bin.install "molden", "gmolden"
  end

  def caveats; <<-EOS.undent
    Two versions of Molden were installed:
      - gmolden is the full OpenGL version
      - molden is the Xwindows version
    EOS
  end

  test do
    # molden is an interactive program, there is not much we can test here
    assert_match "Molden#{version}", shell_output("#{bin}/gmolden -h")
  end
end
