require 'formula'

class Augustus < Formula
  homepage 'http://bioinf.uni-greifswald.de/augustus/'
  url 'http://bioinf.uni-greifswald.de/augustus/binaries/augustus.3.0.1.tar.gz'
  mirror 'https://science-annex.org/pub/augustus/augustus.3.0.1.tar.gz'
  sha1 '19f40b3b834aba0386646d9cb8120caf3f0eb64e'

  depends_on 'boost' => :recommended # for gz support

  fails_with :clang do
    build 503
    cause 'error: invalid operands to binary expression'
  end

  def install
    system 'make'
    rm_r %w[include mysql++ src]
    libexec.install Dir['*']
    bin.install_symlink '../libexec/bin/augustus'
  end

  def caveats; <<-EOS.undent
    Set the environment variable AUGUSTUS_CONFIG_PATH:
      export AUGUSTUS_CONFIG_PATH=#{opt_prefix}/libexec/config
    EOS
  end

  test do
    system 'augustus --version'
  end
end
