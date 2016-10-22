class BamReadcount < Formula
  desc "Count DNA sequence reads at each position in BAM files"
  homepage "https://github.com/genome/bam-readcount"
  # tag "bioinformatics"

  url "https://github.com/genome/bam-readcount/archive/v0.8.0.tar.gz"
  sha256 "4f4dd558e3c6bfb24d6a57ec441568f7524be6639b24f13ea6f2bb350c7ea65f"
  head "https://github.com/genome/bam-readcount.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "17c0f2260c9fe12b1bfc6bf932ed6c103988e547ea68f1df0c972df73dfb0988" => :sierra
    sha256 "62c7ac502fdece44ec104177a97b37aa46e5244a82d3084e1e58f7f3bc528dba" => :el_capitan
    sha256 "6e7c930c6275a04fc69791ae70f3de147face2068cb94a4b18070a727eedc90a" => :yosemite
    sha256 "ea78015b0c0c0b458b72dcc474e53b18afaca3387e23118f32238d1297f87473" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "samtools"

  def install
    samtools = Formula["samtools"].opt_prefix
    ENV["SAMTOOLS_ROOT"] = "#{samtools}:#{samtools}/include/bam"
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "VERBOSE=1"
      system "make", "VERBOSE=1", "install"
    end
  end

  test do
    assert_match "Available options", shell_output("#{bin}/bam-readcount 2>&1", 1)
  end
end
