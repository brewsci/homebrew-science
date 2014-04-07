require 'formula'

class PicardTools < Formula
  homepage 'http://picard.sourceforge.net/'
  url "https://downloads.sourceforge.net/project/picard/picard-tools/1.111/picard-tools-1.111.zip"
  sha1 '9e95512fe6fac65bb711067d026d482909a817af'

  def install
    (share/'java').install Dir['*.jar', "picard-tools-#{version}/*.jar"]
  end

  def caveats
    <<-EOS.undent
      The Java JAR files are installed to
          #{HOMEBREW_PREFIX}/share/java
    EOS
  end

  test do
    system "java -jar #{share}/java/ViewSam.jar --version"
  end
end
