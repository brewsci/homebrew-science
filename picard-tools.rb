class PicardTools < Formula
  homepage "http://broadinstitute.github.io/picard/"
  # tag "bioinformatics"

  url "https://github.com/broadinstitute/picard/releases/download/1.128/picard-tools-1.128.zip"
  sha1 "af24555cf6c673ab95a042fae322a189bee05326"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "c2f770c238596792afd181d405e301f47bb231f4" => :yosemite
    sha1 "5aca6629a51f4169578de0cdfd494ceb836b41ed" => :mavericks
    sha1 "dacf2ca0bd45e6d790196ddc37b3a48f33fc98f1" => :mountain_lion
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
