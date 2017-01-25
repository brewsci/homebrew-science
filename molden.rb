class Molden < Formula
  desc "Pre- and post-processing of molecular and electronic structure"
  homepage "http://www.cmbi.ru.nl/molden/"
  url "ftp://ftp.cmbi.ru.nl/pub/molgraph/molden/molden5.7.tar.gz"
  sha256 "8c52229f1762e987995c53936f0dc2cfd086277ec777bf9083d76c0bf0483887"
  # tag "chemistry"
  # doi "10.1023/A:1008193805436"

  bottle do
    cellar :any
    sha256 "52ef22a806997d35e9d981c1b779ed9c0834eba9e3b9d9c32741b990cab59959" => :sierra
    sha256 "c4a03bcfac4651420a5a626b95b962333045904c91379fe41f3acd88a8660299" => :el_capitan
    sha256 "792ce5702cf158143210a46cde9d15e8301cc8005f27daf4010efc774497b85f" => :yosemite
  end

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
