class Bamtools < Formula
  desc "C++ API and command-line toolkit for BAM data"
  homepage "https://github.com/pezmaster31/bamtools"
  # doi "10.1093/bioinformatics/btr174"
  # tag "bioinformatics"

  url "https://github.com/pezmaster31/bamtools/archive/v2.4.1.tar.gz"
  sha256 "933a0c1a83c88c1dac8078c0c0e82f6794c75cb927265399404bc2cc2611204b"
  head "https://github.com/pezmaster31/bamtools.git"

  bottle do
    cellar :any
    sha256 "e5abdc25d558b613464e597cf22d7c091ff4b5a6e7e39e8b519eff5cdb8771f6" => :sierra
    sha256 "dac25299b7679ed5e5286d20da0a03dd0d2f97fb7742bb45a838edc5982a607f" => :el_capitan
    sha256 "b46516a39fc2a220499236541ea44b4e00382c43441c030d0304bbf24c3f3680" => :yosemite
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
