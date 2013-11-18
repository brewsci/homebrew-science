require 'formula'

class PicardTools < Formula
  homepage 'http://picard.sourceforge.net/'
  version '1.103'
  url "http://downloads.sourceforge.net/project/picard/picard-tools/#{version}/picard-tools-#{version}.zip"
  sha1 'b7d5010be975a17efddf99de3d6dbe361b8cfc3e'

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
