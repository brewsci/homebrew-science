require "formula"

class Bowtie < Formula
  homepage "http://bowtie-bio.sourceforge.net/index.shtml"
  #doi "10.1186/gb-2009-10-3-r25"
  url "https://github.com/BenLangmead/bowtie/archive/v1.0.1.tar.gz"
  sha256 "aedcada44803dbe6e3e2fa7bd13a040733fac95032b4102918612310f5bbaa54"
  head "https://github.com/BenLangmead/bowtie.git"

  fails_with :gcc => "4.8" do
    cause "Build failures with gcc-4.8. Install with --cc=gcc-4.2"
  end

  fails_with :clang do
    build 503
    cause %q[error: reference to 'lock_guard' is ambiguous. See #476]
  end

  def install
    system "make", "allall"

    # preserve directory structure for tests/scripts
    libexec.install %W[
      bowtie bowtie-debug
      bowtie-build bowtie-build-debug
      bowtie-inspect bowtie-inspect-debug
      scripts
      genomes indexes reads
    ]

    bin.install_symlink %W[
      #{libexec}/bowtie
      #{libexec}/bowtie-build
      #{libexec}/bowtie-inspect
    ]

    doc.install %W[AUTHORS LICENSE MANUAL MANUAL.markdown NEWS TUTORIAL]

    inreplace libexec/"scripts/test/simple_tests.pl" do |s|
      s.gsub! "$bowtie = \"\"", "$bowtie = \"#{bin}/bowtie\""
      s.gsub! "$bowtie_build = \"\"", "$bowtie_build = \"#{bin}/bowtie-build\""
    end
  end

  test do
    cd libexec
    system "sh", "./scripts/test/all.sh"
  end
end
