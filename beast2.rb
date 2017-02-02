class Beast2 < Formula
  desc "Bayesian evolutionary analysis by sampling trees"
  homepage "http://www.beast2.org/"
  url "https://github.com/CompEvol/beast2/archive/v2.4.5.tar.gz"
  sha256 "e2ff7c36ad9c216f76c01d0b7181b90d48fd4a7bd16668245fe6b49483c777bf"
  head "https://github.com/CompEvol/beast2.git"
  # tag "bioinformatics"
  # doi "10.1371/journal.pcbi.1003537"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c84c595ada0a3f0f98e6d4f5d40f3ce6cfda0a59daed5b946d427bfb9b2422d" => :sierra
    sha256 "434738145cceed81fcf51ce3aefd72d7197d50a466a37650653283a20ab42b17" => :el_capitan
    sha256 "7d3049869628730b406cee1ba5e6b524e037b9315ab11b13ee0bf738f150d785" => :yosemite
  end

  depends_on :ant => :build
  depends_on :java => "1.8+"

  def install
    # Homebrew renames the unpacked source folder, but build.xml
    # assumes that it won't be renamed.
    inreplace "build.xml", "../beast2/", ""
    system "ant", "linux"

    cd "release/Linux/beast" do
      # Set `beast.user.package.dir` to `opt_pkgshare`. This will:
      # 1) Prevent BEAST from installing packages outside the Homebrew Cellar
      # 2) Preserve addon packages between BEAST version updates
      inreplace Dir["bin/*"], "-cp", "-Dbeast.user.package.dir=#{opt_pkgshare} -cp"
      pkgshare.install "examples"
      libexec.install Dir["*"]

      # Suffix binaries to prevent conflicts with BEAST 1.x
      (libexec/"bin").each_child { |f| bin.install_symlink f => bin/"#{f.basename}-2" }
    end
    doc.install Dir["doc/*"]
  end

  def caveats; <<-EOS.undent
    This install coexists with BEAST 1.x as all scripts are suffixed with '-2':
        beast-2 -help

    Examples and addon packages are installed to:
        #{HOMEBREW_PREFIX}/share/beast2

    Tutorials and other documentation are installed to:
        #{HOMEBREW_PREFIX}/share/doc/beast2
  EOS
  end

  test do
    cp pkgshare/"examples/testCalibration.xml", testpath
    # Run fewer generations to speed up tests
    inreplace "testCalibration.xml", "10000000", "1000000"

    system "#{bin}/beast-2", "-java", "-seed", "1000", "testCalibration.xml"
    system "#{bin}/treeannotator-2", "test.1000.trees", "out.tre"
    system "#{bin}/loganalyser-2", "test.1000.log"
  end
end
