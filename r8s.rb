class R8s < Formula
  desc "Estimate rates and divergence times on phylogenetic trees"
  homepage "http://ceiba.biosci.arizona.edu/r8s/"
  url "http://ceiba.biosci.arizona.edu/r8s/r8s.dist.tgz"
  version "1.8"
  sha256 "3b70c86c5aeff52b42598bd48777881b22104c1c1c4658ebcf96d2da9d9521b4"
  revision 1
  # doi "10.1093/bioinformatics/19.2.301"
  # tag "bioinformatics

  bottle do
    cellar :any
    sha256 "af4d814ddb768aab29200dfbd843e9dfbf927c8aa16b36c5f4a9b8467e1803b6" => :el_capitan
    sha256 "5f04f77efd7469738c9f82390b83807487f9cccc204017473df13f0babfe8010" => :yosemite
    sha256 "25350b1b9e43062e3f391feacdd38b3e748a6805fd378f7952aed1b7e5410e39" => :mavericks
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
