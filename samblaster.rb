class Samblaster < Formula
  desc "Tool to mark duplicates in SAM files"
  homepage "https://github.com/GregoryFaust/samblaster"
  # doi "10.1093/bioinformatics/btu314"
  # tag "bioinformatics"

  url "https://github.com/GregoryFaust/samblaster/archive/v.0.1.23.tar.gz"
  sha256 "0d35ce629771946e3d6fc199025747054e5512bffa1ba4446ed81160fffee57a"
  head "https://github.com/GregoryFaust/samblaster"

  bottle do
    cellar :any_skip_relocation
    sha256 "4137edc9cfa83df097dc67c317dec52c3a782d74d5727540119be4208622f040" => :sierra
    sha256 "b590cc9c46e59698c39d7ed144435d69b778fea516e69975820a49bc890ba6d5" => :el_capitan
    sha256 "4083347ced3f2a97d54bc03136a3eb1466d29023e81f33dd03c3adc578acbd0c" => :yosemite
    sha256 "276c523c8272bf832ca82f2553c6fb758155e989cdc67610cf808eebed940fdd" => :x86_64_linux
  end

  def install
    system "make"
    bin.install "samblaster"
  end

  test do
    system "#{bin}/samblaster", "--version"
  end
end
