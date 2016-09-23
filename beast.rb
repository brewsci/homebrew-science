class Beast < Formula
  desc "Bayesian Evolutionary Analysis Sampling Trees"
  homepage "http://beast.bio.ed.ac.uk/"
  # doi "10.1093/molbev/mss075"
  # tag "bioinformatics"

  url "https://github.com/beast-dev/beast-mcmc/archive/v1.8.3.tar.gz"
  sha256 "1b03318e77064f8d556a0859aadd3c81036b41e56e323364fb278a56a00aff44"
  head "https://github.com/beast-dev/beast-mcmc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "82fa3516a312aaee005f9dbc92999a2d2eeef1ba1b50eac35e0f889a1bc76dce" => :el_capitan
    sha256 "52c9e1b8d502d97239fa94b86e3a64ad91fdcb741513710b3fb85b6dc405e2a1" => :yosemite
    sha256 "10340f6d4d33d941f5c0064933919d5072064120a434eb5d8fa1c29cde194f7f" => :mavericks
    sha256 "55d3f39de9fe6938a7f203ad8302de011a3271ee2c273e3c85c4bf0b423964c7" => :x86_64_linux
  end

  depends_on ant: :build

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
