class Spici < Formula
  desc "Fast local network clustering algorithm"
  homepage "http://compbio.cs.princeton.edu/spici/"
  bottle do
    cellar :any_skip_relocation
    sha256 "6adede55492eaf5a1f1dc54c9ac2834c0ded0dfd7112df19105101e1009de01f" => :el_capitan
    sha256 "8bd7d83bfa2281feb1015797a6e6d09ee8aa48e0881d03d7ab72da5ad2302ce6" => :yosemite
    sha256 "d32af840e1c5103c15e4e2659e3a0ac12c3ce4b57331fcb70f3499e72321d371" => :mavericks
    sha256 "d019e082abc609a37bbf972efcacf0de33f1507d01208f1f372e7fe813334562" => :x86_64_linux
  end

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
