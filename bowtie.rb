require "formula"

class Bowtie < Formula
  homepage "http://bowtie-bio.sourceforge.net/index.shtml"
  #doi "10.1186/gb-2009-10-3-r25"
  url "https://github.com/BenLangmead/bowtie/archive/v1.1.0.tar.gz"
  sha1 "5631ac84b22721b138cd401f0b4b3ec1d68d6b63"
  head "https://github.com/BenLangmead/bowtie.git"

  fails_with :clang do
    build 503
    cause %q[error: reference to 'lock_guard' is ambiguous. See #476]
  end

  def install
    system "make", "allall"

    # preserve directory structure for tests/scripts
    libexec.install Dir["bowtie-*"]
    libexec.install %w[bowtie scripts genomes indexes reads]

    bin.install_symlink "bowtie"
    bin.install_symlink Dir["#{libexec}/bowtie-*"]

    doc.install %W[AUTHORS LICENSE MANUAL MANUAL.markdown NEWS TUTORIAL]

    inreplace libexec/"scripts/test/simple_tests.pl" do |s|
      s.gsub! "$bowtie = \"\"", "$bowtie = \"#{bin}/bowtie\""
      s.gsub! "$bowtie_build = \"\"", "$bowtie_build = \"#{bin}/bowtie-build\""
    end
  end

  test do
    system "perl", "#{libexec}/scripts/test/simple_tests.pl"
  end
end
