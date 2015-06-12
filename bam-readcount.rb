class BamReadcount < Formula
  desc "Count DNA sequence reads at each position in BAM files"
  homepage "https://github.com/genome/bam-readcount"
  # tag "bioinformatics"

  url "https://github.com/genome/bam-readcount/archive/v0.7.4.tar.gz"
  sha256 "4bff2ee56e2f77c6d5d89b4c644448a610e0dde00502a82764d652ca4e6fbd92"

  head "https://github.com/genome/bam-readcount.git"

  depends_on "cmake" => :build
  depends_on "samtools"

  def install
    samtools = Formula["samtools"].opt_prefix
    ENV["SAMTOOLS_ROOT"] = "#{samtools}:#{samtools}/include/bam"
    mkdir "build" do
      system "cmake", "..", *std_cmake_args

      # Build the vendored dependencies
      # Fix a compiler error when building with make -j.
      # See https://github.com/genome/bam-readcount/issues/22
      system "make", "deps"

      system "make"

      # Fix error: INSTALL cannot copy file
      # Fixed upstream. See https://github.com/genome/bam-readcount/issues/21
      bin.install "bin/bam-readcount"
    end
    doc.install "README.textile"
  end

  test do
    assert_match "Available options", shell_output("#{bin}/bam-readcount 2>&1", 1)
  end
end
