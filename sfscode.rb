require 'formula'

class Sfscode < Formula
  homepage 'http://sfscode.sourceforge.net/SFS_CODE/index/index.html'
  url 'https://downloads.sourceforge.net/project/sfscode/sfscode/sfscode_20130725/sfscode_20130725.tgz'
  sha1 '08480e69fb274fc06c929fb20b82ee1739526631'

  def install
    system "make sfs_code convertSFS_CODE"
    bin.install "convertSFS_CODE", "sfs_code"
  end

  test do
    system "#{bin}/sfs_code 2>&1 | grep -q sfs && #{bin}/convertSFS_CODE 2>&1 | grep -q SFS"
  end
end
