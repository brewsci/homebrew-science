class PicardTools < Formula
  desc "Tools for manipulating HTS data and formats"
  homepage "https://broadinstitute.github.io/picard/"
  url "https://github.com/broadinstitute/picard/releases/download/2.5.0/picard-tools-2.5.0.zip"
  sha256 "22614ecf3d65e1471b2cda7e2e3afccd158f0ae133d47ccc9238403e86fbdb74"
  # head "https://github.com/broadinstitute/picard.git"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "51aabb5a819f82a4d56cf451afc55040e2cd3cf9c196c1215ab994a9f06f5cf9" => :el_capitan
    sha256 "19cea4eb5ded78e93e8705c4c7d589097961ad1b1d81ccadd0aea872b6aac67e" => :yosemite
    sha256 "1c822259698184eacf37bbc89e7b0f93b85fca499a1be1db7426255ba33a959b" => :mavericks
    sha256 "4076d3da6231562d8ef56d5c481dc8d17f6d97bcf306a928de1e5abece1e2a7c" => :x86_64_linux
  end

  depends_on :java

  def install
    java = share/"java"
    java.install Dir["*.jar"]
    bin.write_jar_script java/"picard.jar", "picard"
  end

  def caveats
    <<-EOS.undent
      The Picard JAR files are installed to
        #{HOMEBREW_PREFIX}/share/java
    EOS
  end

  test do
    assert_match "USAGE", shell_output("java -jar #{share}/java/picard.jar -h 2>&1", 1)
    assert_match "USAGE", shell_output("#{bin}/picard -h 2>&1", 1)
  end
end
