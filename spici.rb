class Spici < Formula
  desc "Fast local network clustering algorithm"
  homepage "http://compbio.cs.princeton.edu/spici/"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btq078"

  url "http://compbio.cs.princeton.edu/spici/files/SPICi.tar.gz"
  version "20130427"
  sha256 "1edf236a0a605002f9d43a1dfb195913dcb1bec6c8a2620cb2c88866134b4e51"

  def install
    system "./configure",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Extremely fast", shell_output("spici -h 2>&1")
  end
end
