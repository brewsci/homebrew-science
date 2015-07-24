class BamReadcount < Formula
  desc "Count DNA sequence reads at each position in BAM files"
  homepage "https://github.com/genome/bam-readcount"
  # tag "bioinformatics"

  url "https://github.com/genome/bam-readcount/archive/v0.7.4.tar.gz"
  sha256 "4bff2ee56e2f77c6d5d89b4c644448a610e0dde00502a82764d652ca4e6fbd92"

  head "https://github.com/genome/bam-readcount.git"

  bottle do
    cellar :any
    sha256 "dcabd11abe3fb222e77e8ac6ad43e2c5329c26a54d6993cdbab578f30c4d561b" => :yosemite
    sha256 "45a7be6af3210e5e5038b35d371872cfe59f4f532299fbd6b69b8cae16111b8b" => :mavericks
    sha256 "bb1094ef2d35a29caa4b545ef78769970c1d5a88692f0ffc97aef35595378f4c" => :mountain_lion
  end

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
