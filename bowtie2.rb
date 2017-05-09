class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/"
  # doi "10.1038/nmeth.1923"
  # tag "bioinformatics"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.3.2.tar.gz"
  sha256 "20653fec933c23c8c792c8101b8a1db9b55a694ee797afcfba97be85532e8a43"
  head "https://github.com/BenLangmead/bowtie2.git"

  bottle do
    cellar :any
    sha256 "82f24fd7945402f65c4611c57e84dc24af51d198456113b50e1d44c0bdcc006e" => :sierra
    sha256 "596cb08d3d5fe998f3eb9d95157beb0e951c493500180455962b38aeb1603046" => :el_capitan
    sha256 "9cb7f57cf683afc167d516eea185345787f12640b8b1d1c5cd9225d3bd161e0f" => :yosemite
    sha256 "eb9d2e30940b6403dd600646d4ad69e84d6d6ad0348ee996da913c2566f8e663" => :x86_64_linux
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
