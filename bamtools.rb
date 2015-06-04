class Bamtools < Formula
  desc "BamTools: API and command-line toolkit for BAM data"
  homepage "https://github.com/pezmaster31/bamtools"
  # tag "bioinformatics"

  url "https://github.com/pezmaster31/bamtools/archive/v2.3.0.tar.gz"
  sha256 "288046e6d5d41afdc5fce8608c5641cf2b8e670644587c1315b90bbe92f039af"

  head "https://github.com/pezmaster31/bamtools.git"

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
