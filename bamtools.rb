require 'formula'

class Bamtools < Formula
  homepage 'https://github.com/pezmaster31/bamtools'
  url 'https://github.com/pezmaster31/bamtools/archive/v2.3.0.tar.gz'
  sha1 '397d595b373ccc11503856d7e2804833aa8ea811'
  head 'https://github.com/pezmaster31/bamtools.git'

  depends_on 'cmake' => :build

  patch do
    # Install libbamtools in /usr/local/lib.
    # https://github.com/pezmaster31/bamtools/pull/82
    url "https://github.com/sjackman/bamtools/commit/3b6b89d.diff"
    sha1 "89f659243dac265684705b485b5580e7cac559f7"
  end

  def install
    mkdir 'default' do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end

  test do
    system "#{bin}/bamtools", "--version"
  end
end
