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
    sha256 "82fa3516a312aaee005f9dbc92999a2d2eeef1ba1b50eac35e0f889a1bc76dce" => :el_capitan
    sha256 "52c9e1b8d502d97239fa94b86e3a64ad91fdcb741513710b3fb85b6dc405e2a1" => :yosemite
    sha256 "10340f6d4d33d941f5c0064933919d5072064120a434eb5d8fa1c29cde194f7f" => :mavericks
    sha256 "55d3f39de9fe6938a7f203ad8302de011a3271ee2c273e3c85c4bf0b423964c7" => :x86_64_linux
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
