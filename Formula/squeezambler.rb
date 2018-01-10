class Squeezambler < Formula
  homepage "http://chitsazlab.org/software/squeezambler/"
  # doi "10.1093/bioinformatics/btt420"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/hyda/squeezambler-2.0.3-hyda-1.3.1.tar.gz"
  version "2.0.3"
  sha256 "a10893a57a4b651037455b25c2c6856a1dad6122ff7efb223cf556aa97e04e46"

  bottle do
    cellar :any_skip_relocation
    sha256 "247b949cefd6a92b4e7b4d952cdc83f1ec44204167896527de253b31f0173da2" => :x86_64_linux
  end

  # Fix error: 'omp.h' file not found
  needs :openmp

  def install
    odie "Fails to build on Mac OS: error: 'clock_gettime' was not declared in this scope" if OS.mac?

    libexec.install Dir["*"]
    bin.install_symlink "../libexec/bin/squeezambler",
      "../libexec/bin/squeezambler2"
  end

  test do
    system "#{bin}/squeezambler", "--version"
    system "#{bin}/squeezambler2", "--version"
  end
end
