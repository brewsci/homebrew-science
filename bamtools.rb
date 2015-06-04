class Bamtools < Formula
  desc "BamTools: API and command-line toolkit for BAM data"
  homepage "https://github.com/pezmaster31/bamtools"
  # tag "bioinformatics"

  url "https://github.com/pezmaster31/bamtools/archive/v2.3.0.tar.gz"
  sha256 "288046e6d5d41afdc5fce8608c5641cf2b8e670644587c1315b90bbe92f039af"

  head "https://github.com/pezmaster31/bamtools.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "894b4a13a34c4984516ada5832f9b57e3790f1b48e4ebe45a2a4eb869980f42d" => :yosemite
    sha256 "b0c3e294ee6b469517c0b2bc821a2f4f9773d32657d76f0db3fe0634fb5163d5" => :mavericks
    sha256 "b26168e99d0d4ec38e47d47fdd46163655a34d486b0fc400d0430e2617715c7c" => :mountain_lion
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
