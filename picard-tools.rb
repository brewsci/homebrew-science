class PicardTools < Formula
  desc "Tools for manipulating HTS data and formats"
  homepage "https://broadinstitute.github.io/picard/"
  url "https://github.com/broadinstitute/picard/releases/download/2.11.0/picard.jar"
  sha256 "09b67259b69f1b8832f2d9e94365427d26a58733e890cfc629a635ce9b9bd369"
  # head "https://github.com/broadinstitute/picard.git"
  # tag "bioinformatics"

  bottle :unneeded

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
