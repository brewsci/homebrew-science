class Adapterremoval < Formula
  desc "adapter trimming, consensus, and read merging"
  homepage "https://github.com/MikkelSchubert/adapterremoval"
  url "https://github.com/MikkelSchubert/adapterremoval/archive/v2.2.1a.tar.gz"
  version "2.2.1a"
  sha256 "4784c830b2283ea910e6ff488b3791c96a8139101191112166a0608d5c945f7d"
  # doi "10.1186/s13104-016-1900-2"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "a80659b06804bcced83f8987f2911070ca32e45591b3f777a632a4db9bea46b2" => :sierra
    sha256 "ec63493a169d2b49cd323742d18841dd1f5412cdae35f084ea1ced19516a8fb0" => :el_capitan
    sha256 "1804750cf4c2b0eef95f132fc0523b8c1fa17faa741a8becdb98de59d4cb48bb" => :yosemite
  end

  depends_on "bzip2" => :recommended
  depends_on "zlib" => :recommended

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/AdapterRemoval", "--bzip2", \
        "--file1", "#{pkgshare}/examples/reads_1.fq", \
        "--file2", "#{pkgshare}/examples/reads_2.fq", \
        "--basename", "#{testpath}/output"
  end
end
