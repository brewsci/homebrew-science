class Prokka < Formula
  desc "Rapid annotation of prokaryotic genomes"
  homepage "http://www.vicbioinformatics.com/software.prokka.shtml"
  url "https://github.com/tseemann/prokka/archive/v1.12.tar.gz"
  sha256 "845e46c9db167fb1fc9d16c934b7cfd89ddfeb6cd44bd8f42204ae7b4e87adba"
  head "https://github.com/tseemann/prokka.git"
  # doi "10.1093/bioinformatics/btu153"
  # tag "bioinformatics"

  depends_on "Bio::Perl" => :perl
  depends_on "XML::Simple" => :perl
  depends_on "Time::Piece" => :perl if OS.linux?

  depends_on "blast"
  depends_on "infernal"
  depends_on "hmmer"
  depends_on "aragorn"
  depends_on "prodigal"
  depends_on "tbl2asn"
  depends_on "parallel"
  depends_on "minced"

  depends_on "barrnap" => :recommended
  depends_on "rnammer" => :optional

  unless OS.mac?
    depends_on "patchelf" => :build
    depends_on "bzip2"
    depends_on "libidn"
    depends_on "zlib"
  end

  def install
    prefix.install Dir["*"]

    if OS.linux?
      # Use the brewed libidn, zlib and bzip2 rather than the host's.
      system "patchelf",
        "--set-rpath", [HOMEBREW_PREFIX, Formula["libidn"].lib, Formula["zlib"].lib].join(":"),
        "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
        prefix/"binaries/linux/tbl2asn"

      system "patchelf",
        "--set-rpath", [HOMEBREW_PREFIX, Formula["bzip2"].lib, Formula["zlib"].lib].join(":"),
        "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
        prefix/"binaries/linux/makeblastdb"

      system "patchelf",
        "--set-rpath", [HOMEBREW_PREFIX, Formula["bzip2"].lib, Formula["zlib"].lib].join(":"),
        "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
        prefix/"binaries/linux/blastp"
    end
  end

  def post_install
    system "#{bin}/prokka", "--setupdb"
  end

  test do
    assert_match "locustag", shell_output("#{bin}/prokka --help 2>&1", 1)
  end
end
