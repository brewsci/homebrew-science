class Augustus < Formula
  desc "predict genes in eukaryotic genomic sequences"
  homepage "http://bioinf.uni-greifswald.de/augustus/"
  # doi "10.1093/nar/gkh379"
  # tag "bioinformatics"

  url "http://bioinf.uni-greifswald.de/augustus/binaries/augustus-3.2.2.tar.gz"
  mirror "http://bioinf.uni-greifswald.de/augustus/binaries/old/augustus-3.2.2.tar.gz"
  sha256 "bb36fcaaaab32920908e794d04e6cb57a0c61d689bfbd31b9b6315233ea3559e"

  bottle do
    sha256 "0eb60809dd6fc0294210b4eaae29363d9034be074d972bd76b32fa9183a18494" => :el_capitan
    sha256 "91143f0a59709e16e435ba220909c7878cbcbd5d3ef41fded2fc1784626eb5ce" => :yosemite
    sha256 "df27039f7d44a9431f38c21816431190220d54a8fd89506c367a35b600c0befb" => :mavericks
    sha256 "1386ac0dbf5c2d54ff0d09760e1b723901f8aa89f99423aca1c155f178b23093" => :x86_64_linux
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
