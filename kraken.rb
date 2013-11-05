require 'formula'

class Kraken < Formula
  homepage 'http://ccb.jhu.edu/software/kraken/'
  url 'http://ccb.jhu.edu/software/kraken/dl/kraken-0.10.0-beta.tgz'
  sha1 '2506704b2cb927bc50498099f98aa625ff675daf'

  fails_with :clang do
    build 500
    cause "error: 'omp.h' file not found"
  end

  fails_with :llvm do
    build 500
    cause "error: 'omp.h' file not found"
  end

  def install
    libexec.mkdir
    system './install_kraken.sh', libexec
    bin.install_symlink(['kraken', 'kraken-build', 'kraken-report'].map do
      |x| '../libexec/' + x
    end)
  end

  test do
    system 'kraken --version'
  end
end
