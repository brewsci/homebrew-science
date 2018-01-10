class Paml < Formula
  desc "phylogenetic analysis by maximum likelihood"
  homepage "http://abacus.gene.ucl.ac.uk/software/paml.html"
  url "http://abacus.gene.ucl.ac.uk/software/paml4.9e.tgz"
  version "4.9e"
  sha256 "460fabe0c8be9e572e755061abe915449bdc7ee806400119e4f0e1e81234ee8f"
  # doi "10.1093/molbev/msm088"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ef1f19920c6625ce662882107030b542ed5afc6d9caddaa1b01cf7dfba51c47" => :sierra
    sha256 "2821220a2b3a8ab458870ffba34b8b32140550130b6a229d5245763ea09be5e3" => :el_capitan
    sha256 "8b0dda43814741d20fb05e27ab458b92ed48d554a24ea7b24e64c189570b4382" => :yosemite
    sha256 "a25505939d68220c19a494a190016a951f5f8ddc846de5484a007e763aabbfbd" => :x86_64_linux
  end

  def install
    # Restore permissions, as some are wrong in the tarball archives
    chmod_R "u+rw", "."

    cd "src" do
      system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
      bin.install %w[baseml basemlg chi2 codeml evolver infinitesites mcmctree pamp yn00]
    end

    pkgshare.install "dat"
    pkgshare.install Dir["*.ctl"]
    doc.install Dir["doc/*"]
    doc.install "examples"
  end

  def caveats
    <<-EOS.undent
      Documentation and examples:
        #{HOMEBREW_PREFIX}/share/doc/paml
      Dat and ctl files:
        #{HOMEBREW_PREFIX}/share/paml
    EOS
  end

  test do
    cp Dir[doc/"examples/DatingSoftBound/*.*"], testpath
    system "#{bin}/infinitesites"
  end
end
