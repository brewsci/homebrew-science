class Augustus < Formula
  desc "predict genes in eukaryotic genomic sequences"
  homepage "http://bioinf.uni-greifswald.de/augustus/"
  # doi "10.1093/nar/gkh379"
  # tag "bioinformatics"

  url "http://bioinf.uni-greifswald.de/augustus/binaries/augustus-3.2.2.tar.gz"
  mirror "http://bioinf.uni-greifswald.de/augustus/binaries/old/augustus-3.2.2.tar.gz"
  sha256 "bb36fcaaaab32920908e794d04e6cb57a0c61d689bfbd31b9b6315233ea3559e"
  revision 1

  bottle do
    sha256 "40e3004de6efeab4b5c51a8cdcd550da16e67c9e7d88c303bb9ad0c5ea28c858" => :el_capitan
    sha256 "1eed43538484957cbf3a21dec725950adac6620b57f93f0c0686fc1038c931fa" => :yosemite
    sha256 "51383cc511a460b6c9cf301a862d991b25e3f2e8d0e9ed51dfa1a27d03c61749" => :mavericks
    sha256 "e8bf9a9233f323f203e58c688ded56dcf97f2bab3d13c40947a480b0733f223d" => :x86_64_linux
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
