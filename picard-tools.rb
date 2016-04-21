class PicardTools < Formula
  desc "Tools for manipulating HTS data and formats"
  homepage "https://broadinstitute.github.io/picard/"
  # tag "bioinformatics"

  url "https://github.com/broadinstitute/picard/releases/download/2.2.4/picard-tools-2.2.4.zip"
  sha256 "233b16ce282fb4612c32b9d255e5cdf19f10685c5c76cb357fad49fd5d80d5bb"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba34b255599802feca4996b7cfe7c619b4c5a0b99368f974dd6d2aaa3db8630e" => :el_capitan
    sha256 "b4b3412c243acae498394393c0a61897d0440dc32b4b1240c784dfc68427d897" => :yosemite
    sha256 "0065ca96c0051d196a5313d891ed2b2ffce6fe618c881a1c732d4a5b4790b0ac" => :mavericks
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
