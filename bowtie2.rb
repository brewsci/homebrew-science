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
    sha256 "15264f6251bc52b95ba3ab3dae015fa7afeb7a64a1be2638d17e67915b184587" => :sierra
    sha256 "505e058d3ed28ad98dc848314919bad50c84144c9da45e8e3e2a29c2b6cc52cd" => :el_capitan
    sha256 "c558d87cf2bd95b3e47740403f48cc38d48abb5c80f677806c2b36082dc2a8a4" => :yosemite
    sha256 "fdc9bc2fdd71b0ed446c955e93bf8c3812462a25775e2eafe9cc76eab86a94f0" => :x86_64_linux
  end

  option "without-tbb", "Build without using Intel Thread Building Blocks (TBB)"

  depends_on "tbb" => :recommended

  def install
    if build.with? "tbb"
      system "make", "install", "WITH_TBB=1",
             "EXTRA_FLAGS=-L #{HOMEBREW_PREFIX}/lib",
             "INC=-I #{HOMEBREW_PREFIX}/include", "prefix=#{prefix}"
    else
      system "make", "install", "prefix=#{prefix}", "NO_TBB=1"
    end
    pkgshare.install "example", "scripts"
  end

  test do
    system "#{bin}/bowtie2-build", "#{pkgshare}/example/reference/lambda_virus.fa", "lambda_virus"
    assert File.exist?("lambda_virus.1.bt2")
  end
end
