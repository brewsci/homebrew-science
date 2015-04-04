class Beast < Formula
  homepage "http://beast.bio.ed.ac.uk/"
  # doi "10.1093/molbev/mss075"
  # tag "bioinformatics"

  url "http://tree.bio.ed.ac.uk/download.php?id=92&num=3"
  version "1.8.2"
  sha1 "47a5aca20fecf6cb61a301f8b03d1e750858721a"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "e1357fad70b3a51ce734a705667f2e9d16bdddf480bf340559cdad0bbcaacb65" => :yosemite
    sha256 "c411831dc26441e4b5bd92dc1926fbd8171d5c8d26d17239f2ce1e9604f67f8b" => :mavericks
    sha256 "c3974c08c01dfa26db9407b070b4302a109043725fef586b4d82290603f2dfee" => :mountain_lion
  end

  head do
    url "https://beast-mcmc.googlecode.com/svn/trunk/"
    depends_on :ant
  end

  def install
    system "ant", "linux" if build.head?

    # Move jars to libexec
    inreplace Dir["bin/*"] do |s|
      s["$BEAST/lib"] = "$BEAST/libexec"
    end

    mv "lib", "libexec"
    prefix.install Dir[build.head? ? "release/Linux/BEASTv*/*" : "*"]
  end

  test do
    system "#{bin}/beast", "-help"
  end

  def caveats; <<-EOS.undent
    Examples are installed in:
      #{opt_prefix}/examples/
    EOS
  end
end
