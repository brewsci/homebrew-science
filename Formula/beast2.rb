class Beast2 < Formula
  desc "Bayesian evolutionary analysis by sampling trees"
  homepage "https://www.beast2.org/"
  url "https://github.com/CompEvol/beast2/archive/v2.4.7.tar.gz"
  sha256 "3b7d8fd53f6440a94e07e89a65d26c8cb47a25e4604fd3367191567891e21b84"
  head "https://github.com/CompEvol/beast2.git"
  # tag "bioinformatics"
  # doi "10.1371/journal.pcbi.1003537"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa776e04245d73a355d725dc7eed2f164345bad3aefcaf2268df9e20d0ecc137" => :sierra
    sha256 "9c1d709a5b99de74457d0d3e256e140cc48ba64cbe3a16680a9be801eb2c1f08" => :el_capitan
    sha256 "02a85d6102eb0df14c7f57f215047f692e37ae3954239dd2916243f49892202d" => :yosemite
    sha256 "305ee722435c5cab6d3b81b7a556df653a77f56c65a7a4a5c7b0342f87e94560" => :x86_64_linux
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
