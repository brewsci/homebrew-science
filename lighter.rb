class Lighter < Formula
  homepage "https://github.com/mourisl/Lighter"
  # tag 'bioinformatics'
  # doi '10.1186/s13059-014-0509-9'
  url "https://github.com/mourisl/Lighter/archive/v1.0.4.tar.gz"
  head "https://github.com/mourisl/Lighter.git"
  sha1 "32d42434999071dcca3b234d199b948f231d2932"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "8c05a07b8c9011d0177079bd7f4d8fd497ddd97f" => :yosemite
    sha1 "e56e3c77862210dafbe0327e01559b5340250cf2" => :mavericks
    sha1 "a2514b84f19e238e77905f574cbbcadc5c6c7e99" => :mountain_lion
  end

  def install
    system "make"
    bin.install "lighter"
    doc.install "README.md", "LICENSE"
  end

  test do
    system "#{bin}/lighter", "-h"
  end
end
