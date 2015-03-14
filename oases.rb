
class Oases < Formula
  homepage "http://www.ebi.ac.uk/~zerbino/oases/"
  # doi "10.1093/bioinformatics/bts094"
  # tag "bioinformatics"

  url "https://www.ebi.ac.uk/~zerbino/oases/oases_0.2.08.tgz"
  sha256 "a90d469bd19d355edf6193dcf321f77216389d2831a849d4c151c1c0c771ab36"

  depends_on "velvet"

  option "with-maxkmerlength=", "Specify maximum k-mer length, any positive odd integer (default: 127)"
  option "with-categories=", "Specify number of categories, any positive integer (default: 2)"

  resource "velvet" do
    url "https://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.10.tgz"
    sha256 "884dd488c2d12f1f89cdc530a266af5d3106965f21ab9149e8cb5c633c977640"
  end

  def install
    ENV.deparallelize

    resource("velvet").stage do
      mkdir buildpath/"velvet"
      cp_r ".", buildpath/"velvet"
    end

    args = ["LONGSEQUENCES=1"]
    args << "OPENMP=1" unless ENV.compiler == :clang

    maxkmerlength = ARGV.value("with-maxkmerlength") || "127"
    args << "MAXKMERLENGTH=#{maxkmerlength}"
    categories = ARGV.value("with-categories") || "2"
    args << "CATEGORIES=#{categories}"

    # don't want to install LaTeX just to make the binary
    inreplace "Makefile", "oases doc", "oases"

    # needs access to .o files from our resource
    inreplace "Makefile", "VELVET_DIR=../velvet", "VELVET_DIR=./velvet\n.PHONY: velvet"

    system "make", *args

    bin.install "oases", "scripts/oases_pipeline.py"
    doc.install "README.txt", "LICENSE.txt", "ChangeLog", "doc"
  end

  test do
    assert_match "Zerbino", shell_output("oases 2>&1", 1)
    assert_match "KMERGE", shell_output("oases_pipeline.py 2>&1", 1)
  end
end
