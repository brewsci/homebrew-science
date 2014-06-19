require 'formula'

class PicardTools < Formula
  homepage 'http://picard.sourceforge.net/'
  url "https://downloads.sourceforge.net/project/picard/picard-tools/1.115/picard-tools-1.115.zip"
  sha1 '470b8c481ff082c3720b78cc3df47f9a1a9b0cc7'

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
