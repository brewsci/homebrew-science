class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/"
  # doi "10.1038/nmeth.1923"
  # tag "bioinformatics"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.3.3.tar.gz"
  sha256 "7d4d455a4af70d02a1ae4ce1a0b21b7d3018737dd197579e1a5612a5c01887c8"
  head "https://github.com/BenLangmead/bowtie2.git"

  bottle do
    cellar :any
    sha256 "e98014fb3fce6541d662fd9b28c99bad72922cf5a95655ce80f46c67fd4b9a09" => :sierra
    sha256 "198f0e7175beee234eab8825397933f3eb8f448cd4061fb2fe05f4ed2cf67355" => :el_capitan
    sha256 "de5b86a2fc5ee255c3b78972f27ac748fe960a95f45f119fc21d018cebaea190" => :yosemite
    sha256 "1a322927459d9b4290643362ff45af8ddb6ef545670015dd4c538e216aee626b" => :x86_64_linux
  end

  option "without-tbb", "Build without using Intel Thread Building Blocks (TBB)"

  depends_on "tbb" => :recommended

  def install
    ENV.delete("SDKROOT") if MacOS.version == :el_capitan

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
