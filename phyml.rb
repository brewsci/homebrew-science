class Phyml < Formula
  desc "Fast maximum likelihood-based phylogenetic inference"
  homepage "http://www.atgc-montpellier.fr/phyml/"
  url "https://github.com/stephaneguindon/phyml/archive/v3.3.20170530.tar.gz"
  sha256 "f826726cd56b755be75f923abdf29aca8a9951d6af948cddbab40739a8f99f74"
  # tag "bioinformatics"
  # doi "10.1093/sysbio/syq010"

  bottle do
    cellar :any_skip_relocation
    sha256 "96c762a5ea82c4fdfa6369371eb05a2ac33852c7c60f7b065ae2e88a49852257" => :sierra
    sha256 "d9de8865da3981c1ff738b80a61d11c725beaa6f7bd8b2edb485f5016d921ff7" => :el_capitan
    sha256 "c9593560d779728c268ce43422623f4529e68753f1d59ec99ccb25695fdb9075" => :yosemite
    sha256 "6ad02dc4e8254ecb2a7e899c78473e81409c9aa135fff108096429397e2128d8" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    # fatal error: 'malloc.h' file not found
    # Upstream issue from 31 Jan 2017 https://github.com/stephaneguindon/phyml/issues/52
    inreplace "src/utilities.h", "#include <malloc.h>", "" if OS.mac?

    system "./autogen.sh"

    # separate steps required
    system "./configure", "--prefix=#{prefix}"
    system "make"

    bin.install "src/phyml"
    doc.install "doc/phyml-manual.pdf"
    pkgshare.install Dir["examples/*"]
  end

  def caveats; <<-EOS.undent
    Examples have been installed here:
      #{opt_pkgshare}

    See options for phyml by running:
      phmyl --help

    PhyML must be run with the "-i" option to specify an input or it will
    segfault. Example:
      phyml -i #{opt_pkgshare}/nucleic
    EOS
  end
end
