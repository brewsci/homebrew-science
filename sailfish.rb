class Sailfish < Formula
  homepage "http://www.cs.cmu.edu/~ckingsf/software/sailfish"
  # doi "10.1038/nbt.2862"
  # tag "bioinformatics"
  url "https://github.com/kingsfordgroup/sailfish/archive/v0.6.3.tar.gz"
  sha256 "5fded7dc88e525d17eb7abe102ac8ce8d8c3c8e9997d8aa1c512dddbef813632"

  depends_on "cmake" => :build
  depends_on "boost" => :recommended
  depends_on "tbb" => :recommended

  keg_only "sailfish conflicts with jellyfish."

  fails_with :clang do
    cause "Currently, the only supported compiler is GCC(>=4.7). We hope to support Clang soon."
  end

  fails_with :gcc do
    build 5666
    cause "Sailfish requires g++ 4.7 or greater."
  end

  def install
    ENV.deparallelize
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/sailfish", "--version"
  end
end
