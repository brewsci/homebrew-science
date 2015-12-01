class Mathomatic < Formula
  homepage "http://www.mathomatic.org/"
  url "http://mathomatic.orgserve.de/mathomatic-16.0.5.tar.bz2"
  sha256 "976e6fed1014586bcd584e417c074fa86e4ca6a0fcc2950254da2efde99084ca"

  head do
    url "http://mathomatic.orgserve.de/am.tar.bz2"
    sha256 "82b17e6fa26d8a88f4836c51dfe9438a95fe2c7ff29ded58a27246c72cf1bafe"
  end

  def install
    ENV["prefix"] = prefix
    system "make READLINE=1"
    system "make m4install"
    cd "primes" do
      system "make"
      system "make", "install"
    end
  end
end
