class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "http://bowtie-bio.sf.net/bowtie2"
  # doi "10.1038/nmeth.1923"
  # tag "bioinformatics"

  url "https://github.com/BenLangmead/bowtie2/archive/v2.2.9.tar.gz"
  sha256 "af940f77fc36aabea90d3d865724fd7ec7e250788d2d2f793c45c713d16ae5ee"

  head "https://github.com/BenLangmead/bowtie2.git"

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
    system "bowtie2-build", "#{pkgshare}/example/reference/lambda_virus.fa", "lambda_virus"
    assert File.exist?("lambda_virus.1.bt2")
  end
end
