class Muscle < Formula
  desc "Multiple sequence alignment program"
  homepage "https://www.drive5.com/muscle/"
  url "https://www.drive5.com/muscle/muscle_src_3.8.1551.tar.gz"
  sha256 "c70c552231cd3289f1bad51c9bd174804c18bb3adcf47f501afec7a68f9c482e"
  # doi "10.1093/nar/gkh340", "10.1186/1471-2105-5-113"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "e772cd2b482c3fc892485504ccae0ee5a486cb00a57b8e6e154b9f20d0d201e5" => :sierra
    sha256 "46fb3219f56a068c718f6b7f3a8d13db9a4b7c6c9483a969da16c7588e59a4e1" => :el_capitan
    sha256 "7b9fdbd97e273d81c87881e2b58151311221aeaedca1b875c560232d831c0b30" => :yosemite
    sha256 "c554628301f042c9803c045da94ea9109c414b277f994cd6fc07763c93c7e510" => :x86_64_linux
  end

  def install
    # Fix build per Makefile instructions
    inreplace "Makefile", "-static", ""

    system "make"
    bin.install "muscle"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/muscle -version")
  end
end
