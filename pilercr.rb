class Pilercr < Formula
  desc "Finding CRISPR repeats in genome sequences"
  homepage "http://drive5.com/pilercr/"
  # doi "doi:10.1186/1471-2105-8-18"
  # tag "bioinformatics"

  url "http://www.drive5.com/pilercr/pilercr1.06.tar.gz"
  sha256 "50175f7aa171674cda5ba255631f340f9cc7f80e8cc25135a4cb857147d91068"

  depends_on "muscle"

  def install
    system "make", "CC=#{ENV.cc} -c", "GPP=#{ENV.cxx}", "LDLIBS=-lm"
    bin.install "pilercr"
  end

  test do
    system "#{bin}/pilercr", "-version"
  end
end
