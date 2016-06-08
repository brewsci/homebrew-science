class RnaStar < Formula
  desc "RNA-seq aligner"
  homepage "https://github.com/alexdobin/STAR"
  # doi "10.1093/bioinformatics/bts635"
  # tag "bioinformatics"

  url "https://github.com/alexdobin/STAR/archive/STAR_2.4.1d.tar.gz"
  sha256 "1c895fc4111798d62a0497c5746f3ae25fdd3f41a0afc4becd90959de183cd5b"

  head "https://github.com/alexdobin/STAR.git"

  bottle do
    cellar :any
    sha256 "b1581ed25ac7dd736acfbe4db632031b3885744bf5e71e7455734696d51e0a92" => :yosemite
    sha256 "98cec003bf3ee5f234a4e161f305fb30fb39eb4f53c2a7f5e24beb8a1facf2c3" => :mavericks
    sha256 "467ee2a2ffbe6c5346d744d43cbe0460ad3607756a37ea6702bd75611a333be8" => :mountain_lion
    sha256 "7e519c1b6d87f138bd0b88d6e6c8680af54fb3b2e4922992a0d66ff1fcef27cf" => :x86_64_linux
  end

  # Fix error: 'omp.h' file not found
  needs :openmp

  def install
    cd "source" do
      system "make", "htslib"
      system "make", OS.mac? ? "STARforMac" : "STAR"
      bin.install "STAR"
    end
    doc.install "CHANGES", "LICENSE", "README", "RELEASEnotes", "doc/STARmanual.pdf"
  end

  test do
    system "#{bin}/STAR", "--version"
  end
end
