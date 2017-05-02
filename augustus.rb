class Augustus < Formula
  desc "predict genes in eukaryotic genomic sequences"
  homepage "http://bioinf.uni-greifswald.de/augustus/"
  # doi "10.1093/nar/gkh379"
  # tag "bioinformatics"

  url "http://bioinf.uni-greifswald.de/augustus/binaries/augustus-3.2.2.tar.gz"
  mirror "http://bioinf.uni-greifswald.de/augustus/binaries/old/augustus-3.2.2.tar.gz"
  sha256 "bb36fcaaaab32920908e794d04e6cb57a0c61d689bfbd31b9b6315233ea3559e"
  revision 2

  bottle do
    sha256 "7d0d1c0394043d7e42355c1e60b518742eb71e78f5ee8646372b7af70253cfa4" => :sierra
    sha256 "4bdbf5b27ca936b464d0880117f326ecf774e18e0e6cd187cd1f58c6215107ba" => :el_capitan
    sha256 "529df4bdb3ed0f438c7401a4adea1afd3eec26d879779555bf94557f60894296" => :yosemite
    sha256 "e666eb765f5e4774cfbc69fb2262696016aee1201bdf1d3f8499a1ac56d7785c" => :x86_64_linux
  end

  option "with-cgp",  "Enable comparative gene prediction"

  depends_on "bamtools"
  depends_on "boost"

  if build.with? "cgp"
    depends_on "gsl"
    depends_on "lp_solve"
    depends_on "suite-sparse"
  end

  def install
    args = []
    args << "COMPGENEPRED=true" if build.with? "cgp"

    system "make", "-C", "auxprogs/filterBam/src", "BAMTOOLS=#{Formula["bamtools"].opt_include}/bamtools", *args
    system "make", "INCLUDES=#{Formula["bamtools"].opt_include}/bamtools", *args

    rm_r %w[include src]
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  def caveats; <<-EOS.undent
    Set the environment variable AUGUSTUS_CONFIG_PATH:
      export AUGUSTUS_CONFIG_PATH=#{opt_prefix}/libexec/config
    EOS
  end

  test do
    system "#{bin}/augustus", "--version"
  end
end
