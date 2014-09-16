require 'formula'

class PicardTools < Formula
  homepage "http://broadinstitute.github.io/picard/"
  url "https://github.com/broadinstitute/picard/releases/download/1.120/picard-tools-1.120.zip"
  sha1 "355a9bdb9d11b1669ff340535307d481e985599d"

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
