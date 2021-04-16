class Seqdb < Formula
  desc "High-throughput compression of FASTQ data"
  homepage "https://bitbucket.org/mhowison/seqdb"
  url "https://bitbucket.org/mhowison/seqdb/downloads/seqdb-0.2.1.tar.gz"
  sha256 "44d1ca6a40701de75fb86936346ef843d3180ea8b9d7591739bdafa7415c484b"
  # doi "10.1109/TCBB.2012.160"
  # tag "bioinformatics"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any, sierra:       "8c4b878ffc024f683bfad217172fbd112981acf8bc73e7df1332d57058ec1f39"
    sha256 cellar: :any, el_capitan:   "5ff9b6b160d8adf93d7b4f9c7d89db573efdda3f0b2f2709502b44b6356eb6ae"
    sha256 cellar: :any, yosemite:     "d22d3781870d9ab168fd93f2f5ffc00a993c1e88a76374f159e310097687cf9b"
    sha256 cellar: :any, x86_64_linux: "ca97c2370d40f13865df25729a5c1d84ac2d136668dfc5ab4a1ffd1e2f036813"
  end

  depends_on "hdf5"

  needs :openmp

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Howison", shell_output("#{bin}/seqdb cite 2>&1")
  end
end
