require 'formula'

class PicardTools < Formula
  homepage 'http://picard.sourceforge.net/'
  url "https://downloads.sourceforge.net/project/picard/picard-tools/1.113/picard-tools-1.113.zip"
  sha1 '29cc4f58499be5eb263643988d003b3d4b845bbe'

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
