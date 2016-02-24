class PicardTools < Formula
  homepage "https://broadinstitute.github.io/picard/"
  # tag "bioinformatics"

  url "https://github.com/broadinstitute/picard/releases/download/2.1.0/picard-tools-2.1.0.zip"
  sha256 "637464a5cb234d85cfc770a7ba65b4e358e0cc08786019b67567923bc3c574db"

  bottle do
    cellar :any
    sha256 "4a28bac04c90b6da227cf132a20fe176f1ba42948764720dc820fb53252b18b6" => :yosemite
    sha256 "de79e09f3c2c3522369e5f281f12f9e304fe60cb8bd69d7837a0c4bdc17cdc2d" => :mavericks
    sha256 "5eac46b16faa9517cb8872e5a3804d8250e42d5aa7bc95cac3c3085beff64ea3" => :mountain_lion
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
