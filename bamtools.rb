class Bamtools < Formula
  desc "C++ API and command-line toolkit for BAM data"
  homepage "https://github.com/pezmaster31/bamtools"
  # doi "10.1093/bioinformatics/btr174"
  # tag "bioinformatics"

  url "https://github.com/pezmaster31/bamtools/archive/v2.4.1.tar.gz"
  sha256 "933a0c1a83c88c1dac8078c0c0e82f6794c75cb927265399404bc2cc2611204b"
  head "https://github.com/pezmaster31/bamtools.git"
  revision 1

  bottle do
    cellar :any
    sha256 "a2ddf51e957f5eea1d1b8e8335d3a501ba15f8a1852887b3e3ee3d287433c1c2" => :sierra
    sha256 "3d2087614a0cba4229820c1cb983f59036199626a18d89610db7080f3ce7af71" => :el_capitan
    sha256 "cb57551670d0011070b31ea3261dc85fd9eb774af7739eed6780cb7bcb6a652a" => :yosemite
  end

  depends_on "cmake" => :build

  patch do
    # Install libbamtools in /usr/local/lib; reported 29 July 2013
    url "https://github.com/pezmaster31/bamtools/pull/82.patch?full_index=1"
    sha256 "93a12cac30327699374ebd43516c755458b4ba06d687736180d10e05582ec179"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/bamtools", "--version"
  end
end
