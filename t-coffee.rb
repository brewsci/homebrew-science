class TCoffee < Formula
  desc "Compute, Manipulate Alignment of DNA-RNA-Protein Sequences, Structures"
  homepage "http://www.tcoffee.org/"
  url "https://github.com/cbcrg/tcoffee/archive/v10.00.r1613.tar.gz"
  version "10.00.r1613"
  sha256 "8280e6002167a6adad7a238181657b1febae27c2b2edf4245027daaf55c8c763"
  head "https://github.com/cbcrg/tcoffee.git"
  bottle do
    cellar :any_skip_relocation
    sha256 "bd4da1f25260d3f4457dc06042e2cb7eb5648e99c702e525c49952e1d2d820bb" => :sierra
    sha256 "d90578cbff89b51d6a492e952fe1974e7736afe97b7c6daaa3a517c416e0c462" => :el_capitan
    sha256 "428579ef4a9a9a12813151cadbf6142675c1a2c0b0aafd42ab829693f292f4e6" => :yosemite
    sha256 "e52169d49c7810dbe0a8a0978cdafcc2bfafd22125ef36a9f419eae63a288331" => :x86_64_linux
  end

  # doi "10.1006/jmbi.2000.4042"

  def install
    system "make", "-C", "compile", "t_coffee"
    prefix.install "lib" => "libexec"
    prefix.install Dir["*"]
    bin.install_symlink "../compile/t_coffee"
  end

  test do
    system "#{bin}/t_coffee", "-version"
  end
end
