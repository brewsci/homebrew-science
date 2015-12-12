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
    sha256 "0eb60809dd6fc0294210b4eaae29363d9034be074d972bd76b32fa9183a18494" => :el_capitan
    sha256 "91143f0a59709e16e435ba220909c7878cbcbd5d3ef41fded2fc1784626eb5ce" => :yosemite
    sha256 "df27039f7d44a9431f38c21816431190220d54a8fd89506c367a35b600c0befb" => :mavericks
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
