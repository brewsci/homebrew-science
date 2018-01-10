class Biocgal < Formula
  # The name CGAL conflicts with
  # Computational Geometry Algorithms Library
  desc "Tool for computing genome assembly likelihoods"
  homepage "http://bio.math.berkeley.edu/cgal/"
  url "http://bio.math.berkeley.edu/cgal/cgal-0.9.6-beta.tar"
  sha256 "052e2f2c01fc3a5a7e1a0582a17a51668930cde1f73a8a9e5564a65ddb41c47e"

  def install
    system "make"
    bin.install %w[align bfastconvert bowtie2convert cgal]
    doc.install "manual.pdf"
  end

  test do
    system "#{bin}/cgal --help 2>&1 |grep -q cgal"
  end
end
