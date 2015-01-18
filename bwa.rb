class Bwa < Formula
  homepage "http://bio-bwa.sourceforge.net/"
  # doi "10.1093/bioinformatics/btp324"
  # tag "bioinformatics"
  url "https://downloads.sf.net/project/bio-bwa/bwa-0.7.12.tar.bz2"
  sha1 "6389ca75328bae6d946bfdd58ff4beb0feebaedd"
  head "https://github.com/lh3/bwa.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "5516077fa560538fb8b5cd81f91cca7042c8fc20" => :yosemite
    sha1 "fa5a7775d5eeeb2937461117f04ce10dc3d950f6" => :mavericks
    sha1 "8eb305655875446c43e69d3bd6c794342939d614" => :mountain_lion
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "bwa"
    doc.install %w[README.md NEWS.md]
    man1.install "bwa.1"
  end

  test do
    (testpath/"test.fasta").write ">0\nMEEPQSDPSV\n"
    system "#{bin}/bwa index test.fasta"
    assert File.exist?("test.fasta.bwt")
  end
end
