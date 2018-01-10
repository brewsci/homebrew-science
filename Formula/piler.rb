class Piler < Formula
  desc "Analyze repetitive DNA found in genome sequences"
  homepage "https://drive5.com/piler/"
  # doi "10.1093/bioinformatics/bti1003"
  # tag "bioinformatics"

  version "1.0"
  revision 1
  if OS.mac?
    url "https://drive5.com/piler/piler_pals_osx_src.tar.gz"
    sha256 "68c20b68a6bc73224e15bbaddfb982a7f0b38e04324e25f98d387b7186f981a4"
  elsif OS.linux?
    url "https://drive5.com/piler/piler_source.tar.gz"
    sha256 "3b1be91c497bdb22eac8032a60c9f815bdcd03edc5b25d925314a02f54bec44f"
  else
    raise "Unknown operating system"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "dcb0a2bc15dd739eee21b80db14660b600308a612d0091bfe9cd3161dc3f009d" => :el_capitan
    sha256 "62f3c8a1acf4a28f266937011da857c63608d26c10c2f2a690ce05c9223de17f" => :yosemite
    sha256 "0efdbf451eb1d240ed255ae1dfe2b907c417fb020a99c3496988b94ca721b225" => :mavericks
    sha256 "ca33e46d6173d1b7008a3c6488cbe9c650cabb3383547acce611963d88da12a1" => :x86_64_linux
  end

  depends_on "muscle"

  def install
    cd (if OS.mac? then "piler" else "." end) do
      system "make", "CC=#{ENV.cc} -c", "GPP=#{ENV.cxx}", "LDLIBS=-lm" # remove -static
      if OS.mac?
        bin.install "piler"
      else
        # Why is the executable named differently?
        bin.install "piler2" => "piler"
      end
    end
  end

  test do
    system "#{bin}/piler", "-version"
  end
end
