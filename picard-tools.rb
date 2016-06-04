class PicardTools < Formula
  desc "Tools for manipulating HTS data and formats"
  homepage "https://broadinstitute.github.io/picard/"
  # tag "bioinformatics"

  url "https://github.com/broadinstitute/picard/releases/download/2.2.4/picard-tools-2.2.4.zip"
  sha256 "233b16ce282fb4612c32b9d255e5cdf19f10685c5c76cb357fad49fd5d80d5bb"

  bottle do
    cellar :any_skip_relocation
    sha256 "42fe6b9ed31756fa0c14b5a0a2c52f3ebcf01179ff3a2bea38a50d8907eb1787" => :el_capitan
    sha256 "0c920b6fcca5b84305c52fe8fc5147c5d4979b3b408f71e27eeb998cff21a0ba" => :yosemite
    sha256 "38075522e8f8315d79747032e45b2485d5dc082252f6e7b1924813c1856f5e9e" => :mavericks
    sha256 "7853f4661db79619215494650922585ce2b66edaf7d474e204089a3d6c6144c7" => :x86_64_linux
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
