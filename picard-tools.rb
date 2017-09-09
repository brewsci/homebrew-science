class PicardTools < Formula
  desc "Tools for manipulating HTS data and formats"
  homepage "https://broadinstitute.github.io/picard/"
  url "https://github.com/broadinstitute/picard/releases/download/2.12.0/picard.jar"
  sha256 "f781056a74ec4b731df2f1a7a29673f7f61913528dca476d89180843621cf891"
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
