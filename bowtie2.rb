class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "http://bowtie-bio.sf.net/bowtie2"
  # doi "10.1038/nmeth.1923"
  # tag "bioinformatics"

  url "https://github.com/BenLangmead/bowtie2/archive/v2.2.6.tar.gz"
  sha256 "06d584040d9ce457873c59e4a5889aafe1a5f74ada207793335765d7abdf4eeb"

  head "https://github.com/BenLangmead/bowtie2.git"

  bottle do
    cellar :any
    revision 3
    sha256 "54cb5f64f7bb31735197f87f256831bd896fecccf160ce215ede93f729fe45c1" => :el_capitan
    sha256 "3e7bc98fbe7b8a6987f85b8006977fa6d1a8a34b442ab3a49371e303d0798055" => :yosemite
    sha256 "358d4b70caddb0feec272674c5f290bf082165fd785c5f7e203ef1fffa70f730" => :mavericks
  end

  option "without-tbb", "Build without using Intel Thread Building Blocks (TBB)"

  depends_on "tbb" => :recommended

  def install
    if build.with? "tbb"
      system "make", "install", "WITH_TBB=1",
             "EXTRA_FLAGS=-L #{HOMEBREW_PREFIX}/lib",
             "INC=-I #{HOMEBREW_PREFIX}/include", "prefix=#{prefix}"
    else
      system "make", "install", "prefix=#{prefix}"
    end
    pkgshare.install "example", "scripts"
  end

  test do
    system "bowtie2-build", "#{pkgshare}/example/reference/lambda_virus.fa", "lambda_virus"
    assert File.exist?("lambda_virus.1.bt2")
  end
end
