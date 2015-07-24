class PicardTools < Formula
  homepage "http://broadinstitute.github.io/picard/"
  # tag "bioinformatics"

  url "https://github.com/broadinstitute/picard/releases/download/1.128/picard-tools-1.128.zip"
  sha1 "af24555cf6c673ab95a042fae322a189bee05326"

  bottle do
    cellar :any
    sha1 "69f0e158f58319b32cf81c13d4c1b3c08ac1364c" => :yosemite
    sha1 "04d7d6625c93622d98849f1b2f8cdb1a96d5839d" => :mavericks
    sha1 "0e07a4f03c0ddeb224d4a9436974da90baf3ca2e" => :mountain_lion
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
