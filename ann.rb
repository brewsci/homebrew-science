require 'formula'

class Ann < Formula
  homepage 'http://www.cs.umd.edu/~mount/ANN/'
  url 'http://www.cs.umd.edu/~mount/ANN/Files/1.1.2/ann_1.1.2.zip'
  sha1 '622be90314a603ef9b2abadcf62379f73f28f46c'

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "1af4c7a1d3aa264cd62565687859432a872b404962cd22f250e5bedf08d8c8d0" => :yosemite
    sha256 "101435719a743112bc700a56abb483a107ed3dfcba12313ec790db72de9c59a9" => :mavericks
    sha256 "67e681a734fcdd3d4fb1ac79f86cabdd29b4370ea90ddd441e4ad4fc4663c7e9" => :mountain_lion
  end

  def install
    # Fix for Mountain Lion / Mavericks make error
    inreplace 'ann2fig/ann2fig.cpp', 'main', 'int main' if MacOS.version >= :mountain_lion

    system "make", "macosx-g++"
    prefix.install "bin", "lib", "sample", "doc", "include"
  end

  test do
    cd "#{prefix}/sample" do
      system "#{bin}/ann_sample", "-df", "data.pts", "-qf", "query.pts"
    end
  end
end
