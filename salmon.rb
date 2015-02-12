class Salmon < Formula
  homepage "http://www.cs.cmu.edu/~ckingsf/software/sailfish/downloads.html"
  # tag "bioinformatics"

  url "https://github.com/kingsfordgroup/sailfish/archive/v0.2.7.tar.gz"
  sha1 "442226fb38fffd51db2a274f7b5597611b578324"
  head "https://github.com/kingsfordgroup/sailfish.git", :branch => "develop"

  depends_on "cmake" => :build
  depends_on "boost" if build.head?
  depends_on "tbb"

  def install
    # Fix error: Unable to find the requested Boost libraries.
    ENV.deparallelize

    if build.head?
      system "cmake", ".", *std_cmake_args
    else
      # Salmon uses Shark which requires Boost 1.55.0
      system "cmake", "-DFETCH_BOOST=TRUE", ".", *std_cmake_args
    end
    system "make", "install"
  end

  test do
    system "#{bin}/salmon", "--version"
  end
end
