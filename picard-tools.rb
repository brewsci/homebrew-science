class PicardTools < Formula
  desc "Tools for manipulating HTS data and formats"
  homepage "https://broadinstitute.github.io/picard/"
  # tag "bioinformatics"

  url "https://github.com/broadinstitute/picard/releases/download/2.1.1/picard-tools-2.1.1.zip"
  sha256 "8862a27aaedf6a4d2405efaf005d3d0a760eff4046c569275c163a9d3011a576"

  bottle do
    cellar :any_skip_relocation
    sha256 "900f7c9862a456de3b34ade51f4f657d8a209b9e9b15cb2db72458f4916c5be3" => :el_capitan
    sha256 "1d3e17a8122d0369882e2b660fe8b3066b2084358423bca34c4a1e5b1731fdd7" => :yosemite
    sha256 "6a8c1e8e09b4a5881cfad8bd996286c6fc2b3d087163124bd4b5e7f2df48bb3e" => :mavericks
  end

  # head "https://github.com/broadinstitute/picard.git"

  depends_on :java

  def install
    java = share/"java"
    java.install Dir["*.jar"]
    bin.write_jar_script java/"picard.jar", "picard"
    lib.install "libIntelDeflater.so" if OS.linux?
  end

  def caveats
    <<-EOS.undent
      The Picard JAR files are installed to
        #{HOMEBREW_PREFIX}/share/java
    EOS
  end

  test do
    system "java -jar #{share}/java/picard.jar -h 2>&1 |grep Picard"
    system "#{bin}/picard -h 2>&1 |grep Picard"
  end
end
