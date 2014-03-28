require 'formula'

class PicardTools < Formula
  homepage 'http://picard.sourceforge.net/'
  url "https://downloads.sourceforge.net/project/picard/picard-tools/1.110/picard-tools-1.110.zip"
  sha1 'd42421acf7255984c17bcc92134cb055c4db8f7c'

  def install
    (share/'java').install Dir['*.jar', "picard-tools-#{version}/*.jar"]
  end

  def caveats
    <<-EOS.undent
      The Java JAR files are installed to
          #{HOMEBREW_PREFIX}/share/java
    EOS
  end
end
