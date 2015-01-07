class Masurca < Formula
  homepage "http://www.genome.umd.edu/masurca.html"
  #doi "10.1093/bioinformatics/btt476"
  #tag "bioinformatics"

  url "ftp://ftp.genome.umd.edu/pub/MaSuRCA/v2.2.1/MaSuRCA-2.2.1.tar.gz"
  sha1 "a568d0afc9cf96e5351e8f4ef92c1b89a13011d6"

  conflicts_with "jellyfish", :because => "both install lib/libjellyfish-2.0.a"

  depends_on "parallel"

  def install
    raise "MaSuRCA fails to build on Mac OS. See https://github.com/Homebrew/homebrew-science/issues/344" if OS.mac?

    # Fix brew audit: Non-executables were installed to bin
    inreplace "SuperReads/src/fix_unitigs.sh", /^/, "#!/bin/sh\n"
    inreplace "SuperReads/src/run_ECR.sh", /^/, "#!/bin/sh\n"

    # Fix the error ./install.sh: line 46: masurca: No such file or directory
    bin.mkdir
    cp "SuperReads/src/masurca", bin
    chmod 0755, bin/"masurca"

    ENV.deparallelize
    ENV["DEST"] = prefix
    system "./install.sh"

    # Conflicts with parallel
    rm bin/"parallel"
  end

  test do
    system "#{bin}/masurca", "-h"
  end
end
