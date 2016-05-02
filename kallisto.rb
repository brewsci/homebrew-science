class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  # doi "10.1038/nbt.3519"
  # tag "bioinformatics"
  url "https://github.com/pachterlab/kallisto/archive/v0.42.5.tar.gz"
  sha256 "2b30a82cc34c0e6251dca29c03ff8a7430407f8a00e393c91b8664a05d6bac6d"

  bottle do
    cellar :any
    sha256 "8de3e89efbb2ae6792ac9482046978a5c1f73b4095b7dddf03820ee0fce786a2" => :el_capitan
    sha256 "f5dbd2e0bfce5260c0bf697163a7c9c38c5df6f00cfa3dc2d0282fe4ca890045" => :yosemite
    sha256 "116b814beb9756392a7ff18471fb6c79440be81f55c1500a01855a299580f1f5" => :mavericks
  end

  needs :cxx11
  depends_on "cmake" => :build
  depends_on "hdf5"

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    doc.install "README.md"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/kallisto", 1)
  end
end
