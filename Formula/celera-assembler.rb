class CeleraAssembler < Formula
  homepage "https://wgs-assembler.sourceforge.io/"
  # doi "myers2000whole" => "10.1126/science.287.5461.2196",
  #   "levy2007diploid" => "10.1371/journal.pbio.0050254",
  #   "miller2008aggressive" => "10.1093/bioinformatics/btn548"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/wgs-assembler/wgs-assembler/wgs-8.3/wgs-8.3rc1.tar.bz2"
  sha256 "2e000d04273df2cc3ce2514beb812d5772b7127d469d088bb9293e522ae32096"

  bottle do
    sha256 "4e9e12f42fcc8dcc8929bd10317c4eca171c01c03692142ebec7f7520a91d12d" => :yosemite
    sha256 "e3afa1a3b48f5e2711f5b11920ed0e5b6ce913971b410a24c368150720a8e4c8" => :mavericks
    sha256 "7645009d791cae8322451e8796d756442b71a37de851f13fcc41f5b239ab3e8c" => :mountain_lion
    sha256 "5e8fbd9db701ba6633ea0fd6bef2ca68af874efd67b68c52bb04b62baca81abf" => :x86_64_linux
  end

  # Fails with clang: https://sourceforge.net/p/wgs-assembler/bugs/262/
  needs :openmp

  def install
    ENV.deparallelize

    # Search Homebrew library paths before system paths.
    inreplace "src/c_make.as", " /usr/lib64 ", " "

    system "make", "-C", "kmer", "install", "CC=#{ENV.cc}"
    system "make", "-C", "src", "CC=#{ENV.cc}", "LDLIBS=-rdynamic"
    arch = Pathname.new(Dir["*/bin"][0]).dirname
    libexec.install arch
    bin.install_symlink libexec/arch/"bin/runCA"
  end

  test do
    system "#{bin}/runCA"
  end
end
