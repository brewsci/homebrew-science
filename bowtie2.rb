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
    revision 2
    sha256 "37b74fb989023ccec2344ecde15892e511d3c28d5819b439f4f6acc2dc39e458" => :yosemite
    sha256 "46407326318fda1e49ee283b8a243b342ce446cf85052ce14630d3f59b88eced" => :mavericks
    sha256 "5fbb47b87602baf9b14897fc0c36e57462dc60ad962963bcb6f8631c4dc823a6" => :mountain_lion
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
