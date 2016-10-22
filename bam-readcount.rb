class BamReadcount < Formula
  desc "Count DNA sequence reads at each position in BAM files"
  homepage "https://github.com/genome/bam-readcount"
  # tag "bioinformatics"

  url "https://github.com/genome/bam-readcount/archive/v0.8.0.tar.gz"
  sha256 "4f4dd558e3c6bfb24d6a57ec441568f7524be6639b24f13ea6f2bb350c7ea65f"
  head "https://github.com/genome/bam-readcount.git"

  bottle do
    cellar :any
    sha256 "dcabd11abe3fb222e77e8ac6ad43e2c5329c26a54d6993cdbab578f30c4d561b" => :yosemite
    sha256 "45a7be6af3210e5e5038b35d371872cfe59f4f532299fbd6b69b8cae16111b8b" => :mavericks
    sha256 "bb1094ef2d35a29caa4b545ef78769970c1d5a88692f0ffc97aef35595378f4c" => :mountain_lion
    sha256 "b2199666915c1b49439498e75feaba450ffb350897d0e4c21a66aeec499d40a7" => :x86_64_linux
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
