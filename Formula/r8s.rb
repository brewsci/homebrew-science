class R8s < Formula
  desc "Estimate rates and divergence times on phylogenetic trees"
  homepage "https://ceiba.biosci.arizona.edu/r8s/"
  url "https://ceiba.biosci.arizona.edu/r8s/r8s.dist.tgz"
  version "1.8"
  sha256 "3b70c86c5aeff52b42598bd48777881b22104c1c1c4658ebcf96d2da9d9521b4"
  revision 2
  # doi "10.1093/bioinformatics/19.2.301"
  # tag "bioinformatics

  bottle do
    cellar :any
    sha256 "06758a254dd487b553e17ad60b3a2bb4757ea2e9e2b76c42770cc25bffe55967" => :sierra
    sha256 "c7d9568771b00aceef1c14d526df4f741ac88eb7dc867b2edb4198b8b909f909" => :el_capitan
    sha256 "12765e243211314bcc0e5f8eed2757aa9ae8990b6fb778e3f494060471c59d00" => :yosemite
  end

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
    pkgshare.install Dir["SAMPLE_*", "*.pdf"]
  end

  def caveats; <<-EOS.undent
    The manual and example files were installed to
      #{opt_prefix}/share/r8s
    EOS
  end

  test do
    assert_match "r8s version #{version}", shell_output("#{bin}/r8s -v -b", 1)
  end
end
