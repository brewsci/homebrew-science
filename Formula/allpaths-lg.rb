class LinuxRequirement < Requirement
  fatal true
  satisfy OS.linux?
  def message
    "This software only builds on Linux."
  end
end

class AllpathsLg < Formula
  desc "Short read genome assembler"
  homepage "https://www.broadinstitute.org/software/allpaths-lg/blog/"
  # doi "10.1073/pnas.1017351108"
  # tag "bioinformatics"

  url "ftp://ftp.broadinstitute.org/pub/crd/ALLPATHS/Release-LG/latest_source_code/allpathslg-52488.tar.gz"
  sha256 "035b49cb21b871a6b111976757d7aee9c2513dd51af04678f33375e620998542"

  bottle do
    cellar :any_skip_relocation
    sha256 "603ca72cab38d3852a9e3ae35600c3526751e021136cabc1201238edab8fc4f5" => :x86_64_linux
  end

  # Prove us wrong!
  # https://github.com/Homebrew/homebrew-science/issues/1329#issuecomment-68387020
  depends_on LinuxRequirement

  fails_with :clang do
    cause "The only supported compiler is GCC(>=4.7)."
  end

  fails_with :gcc do
    build 5666
    cause "You must compile this with g++ 4.7 or higher."
  end

  def install
    system "./configure",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make", "install"

    # Stripping reduces the size by 20 fold!
    system "strip", *(Dir[bin/"*"] - Dir[bin/"*.p[lm]"])
  end

  test do
    system "#{bin}/RunAllPathsLG", "--version"
  end
end
