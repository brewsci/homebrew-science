class Beast < Formula
  desc "Bayesian Evolutionary Analysis Sampling Trees"
  homepage "http://beast.bio.ed.ac.uk/"
  url "https://github.com/beast-dev/beast-mcmc/archive/v1.8.4.tar.gz"
  sha256 "de8e7dd82eb9017b3028f3b06fd588e5ace57c2b7466ba2e585f9bd8381407af"
  head "https://github.com/beast-dev/beast-mcmc.git"
  # doi "10.1093/molbev/mss075"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0474e953dfb421bb4b0e9fd651d88bf1f19b3b57f98f0e22fe6a835138ece86" => :sierra
    sha256 "e74bc7bb2aa1e5d6985307c25054587ec41385c84313ed6b483d220197d25494" => :el_capitan
    sha256 "e792b0b013879ce8924aebb94808bc0aeaaf3bf33dad792e42abbed4a84e9a9d" => :yosemite
    sha256 "82dd43f312066b7391624defc174baf6573ab00beb3e41772e610466066f22af" => :x86_64_linux
  end

  depends_on :ant => :build
  depends_on :java => "1.7+"

  def install
    system "ant", "linux"
    prefix.install Dir["release/Linux/BEASTv*/*"]

    # Move installed JARs to libexec
    mv lib, libexec

    # Move examples to pkgshare
    pkgshare.install prefix/"examples"

    # Point wrapper scripts to libexec
    inreplace Dir[bin/"*"] do |s|
      s["$BEAST/lib"] = "$BEAST/libexec"
    end
  end

  def caveats; <<-EOS.undent
    Examples are installed in:
      #{opt_pkgshare}/examples/
    EOS
  end

  test do
    cp (opt_pkgshare/"examples"/"clockModels"/"testUCRelaxedClockLogNormal.xml"), testpath

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
