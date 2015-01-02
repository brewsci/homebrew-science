class PicardTools < Formula
  homepage "http://broadinstitute.github.io/picard/"
  #tag "bioinformatics"

  url "https://github.com/broadinstitute/picard/releases/download/1.120/picard-tools-1.120.zip"
  sha1 "355a9bdb9d11b1669ff340535307d481e985599d"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "c2f770c238596792afd181d405e301f47bb231f4" => :yosemite
    sha1 "5aca6629a51f4169578de0cdfd494ceb836b41ed" => :mavericks
    sha1 "dacf2ca0bd45e6d790196ddc37b3a48f33fc98f1" => :mountain_lion
  end

  #head "https://github.com/broadinstitute/picard.git"

  def install
    (share/"java").install Dir["*.jar", "picard-tools-#{version}/*.jar"]
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
