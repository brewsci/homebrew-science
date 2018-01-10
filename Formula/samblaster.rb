class Samblaster < Formula
  desc "Tool to mark duplicates in SAM files"
  homepage "https://github.com/GregoryFaust/samblaster"
  # doi "10.1093/bioinformatics/btu314"
  # tag "bioinformatics"

  url "https://github.com/GregoryFaust/samblaster/archive/v.0.1.24.tar.gz"
  sha256 "72c42e0a346166ba00152417c82179bd5139636fea859babb06ca855af93d11f"
  head "https://github.com/GregoryFaust/samblaster"

  bottle do
    cellar :any_skip_relocation
    sha256 "74c3db0157feee98c2b8eba2b641e14aa9e6ced1f580e26f347176bfd28f2c64" => :sierra
    sha256 "e9eb9875554987fc79f630f473bea38fe291c09e7dcd4ad19de80a220e0ebf45" => :el_capitan
    sha256 "9d84519d0bdf7ad62d1b8177446067ea00fb991e30602ed2c865ea80b8310330" => :yosemite
    sha256 "5b57cad3a0a95239eb69585163e9705b8e7a135af2c7c9724bac74d3038ef6a3" => :x86_64_linux
  end

  def install
    system "make"
    bin.install "samblaster"
  end

  test do
    system "#{bin}/samblaster", "--version"
  end
end
