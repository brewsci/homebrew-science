class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/"
  # doi "10.1038/nmeth.1923"
  # tag "bioinformatics"
  head "https://github.com/BenLangmead/bowtie2.git"

  stable do
    url "https://github.com/BenLangmead/bowtie2/archive/v2.3.0.tar.gz"
    sha256 "9804fddf36233f3f92c11e2250224de3395790cf35c8280c66387075df078221"

    # Remove for > 2.3.0
    # Prevents tophat test from failing
    # Upstream commit from 7 Feb 2017 "Prevent aligner from failing when given
    # empty FASTQ read files"
    patch do
      url "https://github.com/BenLangmead/bowtie2/commit/2e9b960.patch"
      sha256 "074b07ac7b1d1a79469df30e557ea8d8739463298a66b8cee888e26dfde7e4fc"
    end
  end

  bottle do
    cellar :any
    sha256 "254b08af1e191eba7525e0d625d6391443cae89d141279e4c1bda02fa0c6d7e5" => :el_capitan
    sha256 "3a913e85383cd500052dcf9fef4441f8033c094c5bf794701d3d0022436c9852" => :yosemite
    sha256 "5d30d880ba01131c885898ae8a58a57f876a4701f453d33d545e75b5fc3016c6" => :mavericks
    sha256 "20ff4f35289b2ed6f3c4a010980880e7d06d1d6e0900644d60e033a98376ee44" => :x86_64_linux
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
    system "#{bin}/bowtie2-build", "#{pkgshare}/example/reference/lambda_virus.fa", "lambda_virus"
    assert File.exist?("lambda_virus.1.bt2")
  end
end
