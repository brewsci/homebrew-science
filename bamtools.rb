class Bamtools < Formula
  desc "C++ API and command-line toolkit for BAM data"
  homepage "https://github.com/pezmaster31/bamtools"
  # doi "10.1093/bioinformatics/btr174"
  # tag "bioinformatics"

  url "https://github.com/pezmaster31/bamtools/archive/v2.4.0.tar.gz"
  sha256 "f1fe82b8871719e0fb9ed7be73885f5d0815dd5c7277ee33bd8f67ace961e13e"
  revision 1

  head "https://github.com/pezmaster31/bamtools.git"

  bottle do
    cellar :any
    sha256 "578acc620d8f87c7e862a00bed9d79c2d1905bdc76a7e48d13723b89b241da5a" => :el_capitan
    sha256 "6da59ede4461d0a5e34efa4b607f2ce9f59d97ad93f619d7b5ff2c1c48e352be" => :yosemite
    sha256 "f267576a2f0c7b067f88c31dbc440ff05adf78a44500481e4282f12ef478aab4" => :mavericks
    sha256 "e8fe5323b78b0bd7d332d2a22e016f51aafbe245ca9f17ff293e16cacec8a7f1" => :x86_64_linux
  end

  depends_on "cmake" => :build

  patch do
    # Install libbamtools in /usr/local/lib; reported 29 July 2013
    url "https://github.com/pezmaster31/bamtools/pull/82.patch"
    sha256 "960032af95dcd6554329e6707c048c2a59808ea22800b270a268a92f8e67006b"
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
