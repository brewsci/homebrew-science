class CeleraAssembler < Formula
  homepage "http://wgs-assembler.sourceforge.net/"
  # doi "myers2000whole" => "10.1126/science.287.5461.2196",
  #   "levy2007diploid" => "10.1371/journal.pbio.0050254",
  #   "miller2008aggressive" => "10.1093/bioinformatics/btn548"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/wgs-assembler/wgs-assembler/wgs-8.3/wgs-8.3rc1.tar.bz2"
  sha1 "be8e92dc48cdabf64992bc2e4d8b7a39b2f95ff7"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha1 "2a80ee6d9d44414259b847007a3b7e3c499946f4" => :yosemite
    sha1 "4b0bd699c4e9ff6463f4184bfe39b86dc707b3dc" => :mavericks
    sha1 "1d667e16abea494ea04f3cf50109144e6260973f" => :mountain_lion
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
