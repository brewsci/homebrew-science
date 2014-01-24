require 'formula'

class Sailfish < Formula
  homepage 'http://www.cs.cmu.edu/~ckingsf/software/sailfish'
  url 'https://github.com/kingsfordgroup/sailfish/releases/download/v0.6.2/Sailfish-0.6.2-Source.tar.gz'
  sha1 'b8bf01cab7b685fd9b9608bf3e97e25df28e0639'

  depends_on 'cmake' => :build
  depends_on 'boost' => :recommended
  depends_on 'tbb' => :recommended

  keg_only 'sailfish conflicts with jellyfish.'

  fails_with :clang do
    build 500
    cause 'Currently, the only supported compiler is GCC(>=4.7). We hope to support Clang soon.'
  end

  fails_with :gcc do
    build 5666
    cause 'Sailfish requires g++ 4.7 or greater.'
  end

  def install
    ENV.deparallelize
    mkdir 'build' do
      system 'cmake', '..', *std_cmake_args
      system 'make', 'install'
    end
  end

  test do
    system "#{bin}/sailfish --version"
  end
end
