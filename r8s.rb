class R8s < Formula
  desc "Estimate rates and divergence times on phylogenetic trees"
  homepage "http://loco.biosci.arizona.edu/r8s/"
  url "http://loco.biosci.arizona.edu/r8s/r8s.dist.tgz"
  version "1.8"
  sha256 "a388d70275abfabf73a84a4346175ae94b3a3b2f1f399a4d3657bb430a22f903"
  bottle do
    cellar :any
    sha256 "e46feb1ae0e09b56aa5380de42fcccaf828bad63714898a64a973ce8ab5c538f" => :yosemite
    sha256 "bc6200cd561eee09a4a7d0733c68f18ff460b67249d5761d059f19f47d2f15dd" => :mavericks
    sha256 "0b4788187a432ed9762d16d45a209596ce95943f9b802b6b0a61c1b06378c33a" => :mountain_lion
  end

  # doi "10.1093/bioinformatics/19.2.301"
  # tag "bioinformatics"

  depends_on :fortran

  def install
    # Tell r8s where libgfortran is located
    obj_name = OS.linux? ? "libgfortran.so" : "libgfortran.dylib"
    fortran_lib = File.dirname `#{ENV.fc} --print-file-name #{obj_name}`
    inreplace "makefile" do |s|
      s.change_make_var! "LPATH", "-L#{fortran_lib}"
    end
    system "make"
    bin.install "r8s"
    (share/"r8s").install Dir["SAMPLE_*", "*.pdf"]
  end

  def caveats; <<-EOS.undent
    The manual and example files were installed to
      #{opt_prefix}/share/r8s
    EOS
  end

  test do
    assert_match(/r8s version #{version}/, shell_output("#{bin}/r8s -v -b", 1))
  end
end
