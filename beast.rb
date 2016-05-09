class Beast < Formula
  desc "Bayesian Evolutionary Analysis Sampling Trees"
  homepage "http://beast.bio.ed.ac.uk/"
  # doi "10.1093/molbev/mss075"
  # tag "bioinformatics"

  url "https://github.com/beast-dev/beast-mcmc/archive/v1.8.3.tar.gz"
  sha256 "1b03318e77064f8d556a0859aadd3c81036b41e56e323364fb278a56a00aff44"
  head "https://github.com/beast-dev/beast-mcmc.git"

  bottle do
    cellar :any
    sha256 "e1357fad70b3a51ce734a705667f2e9d16bdddf480bf340559cdad0bbcaacb65" => :yosemite
    sha256 "c411831dc26441e4b5bd92dc1926fbd8171d5c8d26d17239f2ce1e9604f67f8b" => :mavericks
    sha256 "c3974c08c01dfa26db9407b070b4302a109043725fef586b4d82290603f2dfee" => :mountain_lion
  end

  depends_on :ant => :build

  def install
    system "ant", "linux"
    prefix.install Dir["release/Linux/BEASTv*/*"]

    # Move installed JARs to libexec
    mv lib, libexec

    # Point wrapper scripts to libexec
    inreplace Dir[bin/"*"] do |s|
      s["$BEAST/lib"] = "$BEAST/libexec"
    end
  end

  def caveats; <<-EOS.undent
    Examples are installed in:
      #{opt_prefix}/examples/
    EOS
  end

  test do
    cp (opt_prefix/"examples"/"clockModels"/"testUCRelaxedClockLogNormal.xml"), testpath

    # Run fewer generations to speed up tests
    inreplace "testUCRelaxedClockLogNormal.xml" do |s|
      s['chainLength="10000000"'] = 'chainLength="500000"'
    end

    system "#{bin}/beast", "-beagle_off", "testUCRelaxedClockLogNormal.xml"

    %W[ops log trees].each do |ext|
      assert File.exist? "testUCRelaxedClockLogNormal." + ext
    end
  end
end
