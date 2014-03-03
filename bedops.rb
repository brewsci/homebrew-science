require 'formula'

class Bedops < Formula
  homepage 'https://github.com/bedops/bedops'
  head 'https://github.com/bedops/bedops.git'

  url 'https://github.com/bedops/bedops/archive/v2.4.1.tar.gz'
  sha1 '0107aac81493b22f81e139a053d32bb926d0af7b'

  fails_with :gcc do
    build 5666
    cause 'error: unrecognized command line option "-std=c++11"'
  end

  def install
    ENV.deparallelize

    # Fix for
    # error: assigning to 'struct object_key *' from incompatible type 'void *'
    # See https://github.com/Homebrew/homebrew-science/issues/666
    ENV.delete 'CC'
    ENV.delete 'CXX'

    system 'make'
    system 'make', 'install'
    bin.install Dir['bin/*']
    doc.install %w[LICENSE README.md]
  end

  test do
    system "#{bin}/bedops", '--version'
  end
end
