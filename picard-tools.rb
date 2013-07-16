require 'formula'

class PicardTools < Formula
  homepage 'http://picard.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/picard/picard-tools/1.82/picard-tools-1.82.zip'
  sha1 '89ab83988425560acbbd2294763d4f8429a7e70d'

  def install
    (share/'java').install Dir['*.jar']
    (share/'java').install Dir['picard-tools-1.82/*.jar']
  end

  def caveats
    <<-EOS.undent
      The Java JAR files are installed to
          #{HOMEBREW_PREFIX}/share/java
    EOS
  end
end
