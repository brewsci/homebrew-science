class Masurca < Formula
  homepage "http://www.genome.umd.edu/masurca.html"
  #doi "10.1093/bioinformatics/btt476"
  #tag "bioinformatics"

  url "ftp://ftp.genome.umd.edu/pub/MaSuRCA/v2.2.1/MaSuRCA-2.2.1.tar.gz"
  sha1 "a568d0afc9cf96e5351e8f4ef92c1b89a13011d6"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "361c41e31d2abf549136bda8d318fc2e804f66ce" => :yosemite
    sha1 "a143f4ae7cefc0b61e65f47646765ca7eaf48ccd" => :mavericks
    sha1 "acaf5da00766a84ecb70db681ea6cc0dd064f59f" => :mountain_lion
  end

  fails_with :clang do
    build 600
    cause "error: use of undeclared identifier 'use_safe_malloc_instead'"
  end

  depends_on "parallel"

  def install
    if OS.mac?
      # Fix error: 'operator()' is not a member of 'reallocator<basic_charb<reallocator<char> > >'
      inreplace "SuperReads/include/reallocators.hpp",
        "reallocator<T>::operator()",
        "reallocator<T>::realloc"

      # Fix ld: library not found for -lrt
      inreplace "SuperReads//Makefile.in", "-lrt", ""

      # Fix cp: CA/Linux-amd64/bin/*: No such file or directory
      inreplace "install.sh", "Linux-amd64", "Darwin-amd64"
    end

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

    # Conflicts with jellyfish
    rm Dir[lib/"libjellyfish*", lib/"pkgconfig/jellyfish-2.0.pc"]

    # Conflicts with parallel
    rm bin/"parallel"
  end

  test do
    system "#{bin}/masurca", "-h"
  end
end
