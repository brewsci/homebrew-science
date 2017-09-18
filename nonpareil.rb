class Nonpareil < Formula
  desc "Estimates coverage in metagenomic datasets."
  homepage "http://enve-omics.ce.gatech.edu/nonpareil"

  # doi "10.1093/bioinformatics/btt584"
  # tag "bioinformatics"
  url "https://github.com/lmrodriguezr/nonpareil/archive/v3.1.tar.gz"
  sha256 "bd07cd39fcc461ee4188daf7887c1dbd2a0ceb22b91e3dd2d37fe2b8fede2079"
  head "https://github.com/lmrodriguezr/nonpareil.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ea1bcb2aa7888f57df8c37e0bb24cb44cc4d9bc55003540b07ab099563191f9" => :sierra
    sha256 "057c794b88ceff0fdd9efc316644927d60a365415d3572c3bf03c4cefbe08239" => :el_capitan
    sha256 "52f99ed9445b629479954f9c95dcf4b98102531d640c9ae1da61492ce6ac8cc2" => :x86_64_linux
  end

  depends_on "r"
  depends_on :mpi => [:cxx, :optional]

  def install
    r_library = lib/"R"/r_major_minor
    r_library.mkpath
    inreplace "Makefile", "CMD INSTALL", "CMD INSTALL --library=#{r_library}"
    system "make", "nonpareil"
    system "make", "mpicpp=#{ENV["MPICXX"]}", "nonpareil-mpi" if build.with? :mpi
    system "make", "prefix=#{prefix}", "mandir=#{man1}", "install"
    libexec.install "test/test.fasta"
  end

  def r_major_minor
    `#{Formula["r"].bin}/Rscript -e 'cat(as.character(getRversion()[1,1:2]))'`.strip
  end

  test do
    cp libexec/"test.fasta", testpath
    system bin/"nonpareil", "-s", "#{testpath}/test.fasta", "-T", "alignment",
                            "-b", "#{testpath}/test"
  end
end
