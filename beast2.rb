class Beast2 < Formula
  desc "Bayesian evolutionary analysis by sampling trees"
  homepage "https://www.beast2.org/"
  url "https://github.com/CompEvol/beast2/archive/v2.4.6.tar.gz"
  sha256 "a1e150927b5e063ed001b8234e87e72771c458e9ac0bf636bd6bbd1d4be255b5"
  head "https://github.com/CompEvol/beast2.git"
  # tag "bioinformatics"
  # doi "10.1371/journal.pcbi.1003537"

  bottle do
    cellar :any_skip_relocation
    sha256 "86dee7362a8ddfd495bffd9045e9cbf48b1a6d1f557db00bbd5e4c207384610a" => :sierra
    sha256 "03c961c801f4d86f5dd5a66f550f6c51dce1570b321a01570be22f23741a65ba" => :el_capitan
    sha256 "543ab0b351024816b1035893d75fd53688e1422f8676d01badc748991ee1bb58" => :yosemite
    sha256 "4a4f8873a5d84174d6fc3be176ac8aa6b2c29f8ead98e46f19fd934e7717e69f" => :x86_64_linux
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
