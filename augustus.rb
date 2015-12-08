class Augustus < Formula
  desc "predict genes in eukaryotic genomic sequences"
  homepage "http://bioinf.uni-greifswald.de/augustus/"
  # doi "10.1093/nar/gkh379"
  # tag "bioinformatics"

  url "http://bioinf.uni-greifswald.de/augustus/binaries/augustus-3.2.1.tar.gz"
  mirror "http://bioinf.uni-greifswald.de/augustus/binaries/old/augustus-3.2.1.tar.gz"
  mirror "https://fossies.org/linux/misc/augustus-3.2.1.tar.gz"
  sha256 "9afac038a92e8cf9e794ca48fb5464e868bece792e0e31f28931f9e6227c4b68"

  bottle do
    cellar :any
    sha256 "de3e868755c82d7e8e51a2fc2905b6c25706f7d9b9862ef14fadd674456777a5" => :yosemite
    sha256 "38dc89023a148892624c4e7359d424a0ce1a2f20a4ab3f960ddc05b870a32278" => :mavericks
    sha256 "d070713a12c97bbe7d975c7cbc0260bb5c315e9e23607fd3f63070fea1050c41" => :mountain_lion
  end

  option "with-cgp",  "Enable comparative gene prediction"
  option "with-zlib", "Enable gzip compressed input"

  depends_on "bamtools"
  depends_on "boost" if build.with? "zlib"

  if build.with? "cgp"
    depends_on "gsl"
    depends_on "lp_solve"
    depends_on "suite-sparse"
  end

  def install
    args = []
    args << "ZIPINPUT=true" if build.with? "zlib"
    args << "COMPGENEPRED=true" if build.with? "cgp"

    system "make", "-C", "auxprogs/filterBam/src", "BAMTOOLS=#{Formula["bamtools"].opt_include}/bamtools", *args
    system "make", "INCLUDES=#{Formula["bamtools"].opt_include}/bamtools", *args

    rm_r %w[include src]
    libexec.install Dir["*"]
    bin.install_symlink "../libexec/bin/augustus"
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
