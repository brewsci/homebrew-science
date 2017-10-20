class Ann < Formula
  desc "Library for Approximate Nearest Neighbor Searching"
  homepage "https://www.cs.umd.edu/~mount/ANN/"
  url "https://www.cs.umd.edu/~mount/ANN/Files/1.1.2/ann_1.1.2.zip"
  sha256 "1b54b58ae697202a09d793de51ee9200fe1d5c39def78d9e8f5c0d08e48afaf5"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c53407253ccd9d5f5e32e3bc41b789ef143911e369522d20ff538bc02d346ad6" => :sierra
    sha256 "61a6eecaed8aa80f604ee2c5997e29cb41c1e453965c00157e0f7fb22df64a20" => :el_capitan
    sha256 "1b8388192aeb11c8729f84d9094807ecfb7503a800fb7819d07e531e38049c02" => :yosemite
    sha256 "623b013fc20d81861d90b45f3acd517a908db17b3ef124c3e5b678107d39fe43" => :mavericks
  end

  def install
    # Fix for Mountain Lion / Mavericks make error
    inreplace "ann2fig/ann2fig.cpp", "main", "int main" if MacOS.version >= :mountain_lion

    system "make", "macosx-g++"
    prefix.install "bin", "lib", "sample", "doc", "include"
  end

  test do
    cd "#{prefix}/sample" do
      system "#{bin}/ann_sample", "-df", "data.pts", "-qf", "query.pts"
    end
  end
end
