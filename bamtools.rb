require 'formula'

class Bamtools < Formula
  homepage 'https://github.com/pezmaster31/bamtools'
  url 'https://github.com/pezmaster31/bamtools/archive/v2.3.0.tar.gz'
  sha1 '397d595b373ccc11503856d7e2804833aa8ea811'
  head 'https://github.com/pezmaster31/bamtools.git'

  depends_on 'cmake' => :build

  def patches
    # Install libbamtools in /usr/local/lib.
    # https://github.com/pezmaster31/bamtools/pull/82
    'https://github.com/sjackman/bamtools/commit/3b6b89d.diff'
  end

  def install
    mkdir 'default' do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end

  def test
    system "#{bin}/bamtools", "--version"
  end
end
