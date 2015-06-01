class RnaStar < Formula
  desc "RNA-seq aligner"
  homepage "https://github.com/alexdobin/STAR"
  # doi "10.1093/bioinformatics/bts635"
  # tag "bioinformatics"

  url "https://github.com/alexdobin/STAR/archive/STAR_2.4.1d.tar.gz"
  sha256 "1c895fc4111798d62a0497c5746f3ae25fdd3f41a0afc4becd90959de183cd5b"

  head "https://github.com/alexdobin/STAR.git"

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
