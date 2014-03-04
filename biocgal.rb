require "formula"

class Biocgal < Formula
  # The name CGAL conflicts with
  # Computational Geometry Algorithms Library

  homepage "http://bio.math.berkeley.edu/cgal/"
  url "http://bio.math.berkeley.edu/cgal/cgal-0.9.6-beta.tar"
  sha1 "154f70d4673b7b0621cb93e16eb604710ccb4ed8"

  def install
    system "make"
    bin.install %w[align bfastconvert bowtie2convert cgal]
    doc.install "manual.pdf"
  end

  test do
    system "#{bin}/cgal --help 2>&1 |grep -q cgal"
  end
end
