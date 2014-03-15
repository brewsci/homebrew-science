require "formula"

class Kraken < Formula
  homepage "http://ccb.jhu.edu/software/kraken/"
  url "http://ccb.jhu.edu/software/kraken/dl/kraken-0.10.3-beta.tgz"
  sha1 "64f88004c341871d883235f4ae7c876c0136b885"

  fails_with :clang do
    build 503
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
