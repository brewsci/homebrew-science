class Piler < Formula
  desc "Analyze repetitive DNA found in genome sequences"
  homepage "http://drive5.com/piler/"
  # doi "10.1093/bioinformatics/bti1003"
  # tag "bioinformatics"

  version "1.0"
  revision 1
  if OS.mac?
    url "http://drive5.com/piler/piler_pals_osx_src.tar.gz"
    sha256 "68c20b68a6bc73224e15bbaddfb982a7f0b38e04324e25f98d387b7186f981a4"
  elsif OS.linux?
    url "http://drive5.com/piler/piler_source.tar.gz"
    sha256 "3b1be91c497bdb22eac8032a60c9f815bdcd03edc5b25d925314a02f54bec44f"
  else
    raise "Unknown operating system"
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
