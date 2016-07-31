class PicardTools < Formula
  desc "Tools for manipulating HTS data and formats"
  homepage "https://broadinstitute.github.io/picard/"
  url "https://github.com/broadinstitute/picard/releases/download/2.5.0/picard-tools-2.5.0.zip"
  sha256 "22614ecf3d65e1471b2cda7e2e3afccd158f0ae133d47ccc9238403e86fbdb74"
  # head "https://github.com/broadinstitute/picard.git"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "42fe6b9ed31756fa0c14b5a0a2c52f3ebcf01179ff3a2bea38a50d8907eb1787" => :el_capitan
    sha256 "0c920b6fcca5b84305c52fe8fc5147c5d4979b3b408f71e27eeb998cff21a0ba" => :yosemite
    sha256 "38075522e8f8315d79747032e45b2485d5dc082252f6e7b1924813c1856f5e9e" => :mavericks
    sha256 "7853f4661db79619215494650922585ce2b66edaf7d474e204089a3d6c6144c7" => :x86_64_linux
  end

  depends_on :java

  def install
    java = share/"java"
    java.install Dir["*.jar"]
    bin.write_jar_script java/"picard.jar", "picard"
  end

  def caveats
    <<-EOS.undent
      The Picard JAR files are installed to
        #{HOMEBREW_PREFIX}/share/java
    EOS
  end

  test do
    assert_match "USAGE", shell_output("java -jar #{share}/java/picard.jar -h 2>&1", 1)
    assert_match "USAGE", shell_output("#{bin}/picard -h 2>&1", 1)
  end
end
