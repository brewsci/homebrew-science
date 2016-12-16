class Beast2 < Formula
  desc "Bayesian evolutionary analysis by sampling trees"
  homepage "http://www.beast2.org/"
  url "https://github.com/CompEvol/beast2/archive/v2.4.4.tar.gz"
  sha256 "1346d359a141723d57c37333ce9d6cbdf0699609e337dbfdcb969ddbff8713c3"
  head "https://github.com/CompEvol/beast2.git"
  # tag "bioinformatics"
  # doi "10.1371/journal.pcbi.1003537"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f76a7dd57419c9172ea6e23ce691552c2fcd524343b5f640e7bea9f3236a533" => :sierra
    sha256 "b133d0e631901ed5aa9d5fb78d42ee4fc190d05fe3e503e78fd7b1706b99b3a3" => :el_capitan
    sha256 "42336915df95fbf81b5dd4bd4ec12e2d35607b09f07c4b27e2e71c9136f8eff0" => :yosemite
    sha256 "1352432cf9ddd0a41c8d5fceca229ea4b6ce9e2f841228d5e14b16f31cee0251" => :x86_64_linux
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

    system "#{bin}/beast-2", "-seed", "1000", "testCalibration.xml"
    system "#{bin}/treeannotator-2", "test.1000.trees", "out.tre"
    system "#{bin}/loganalyser-2", "test.1000.log"
  end
end
