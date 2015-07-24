class Bamtools < Formula
  desc "BamTools: API and command-line toolkit for BAM data"
  homepage "https://github.com/pezmaster31/bamtools"
  # doi "10.1093/bioinformatics/btr174"
  # tag "bioinformatics"

  url "https://github.com/pezmaster31/bamtools/archive/v2.4.0.tar.gz"
  sha256 "f1fe82b8871719e0fb9ed7be73885f5d0815dd5c7277ee33bd8f67ace961e13e"

  head "https://github.com/pezmaster31/bamtools.git"

  bottle do
    cellar :any
    sha256 "c4bf302ba07235cef55ddbb72125186132f312c14837d0852530922f8c68d336" => :yosemite
    sha256 "f16f1cc37d517e51d9cfc2ff39fd1c0b3346b35bc2e8ec9c4fc180a3a95ed9e8" => :mavericks
    sha256 "e3db9f89e38261baed32a4d46eddc96a5e3eb976591145aa2892a4b047bba58d" => :mountain_lion
  end

  depends_on "cmake" => :build

  patch do
    # Install libbamtools in /usr/local/lib.
    # https://github.com/pezmaster31/bamtools/pull/82
    url "https://github.com/sjackman/bamtools/commit/3b6b89d.diff"
    sha256 "de9438e932884a3f941a683984bed32b2eaca5c5483642c5a2253074f4a559ff"
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
