require 'formula'

class Yaha < Formula
  homepage 'http://faculty.virginia.edu/irahall/yaha/'
  url 'http://faculty.virginia.edu/irahall/support/yaha/YAHA.0.1.79.tar.gz'
  sha1 'f8dd4d61e8f30606fc3b4c40451cc9e86f9a7b0b'

  def install
    raise 'Yaha not yet supported for MacOSX' if OS.mac?
    bin.install 'yaha'
    doc.install Dir['YAHA_User_Guide*.pdf']
  end

  test do
    system 'yaha'
  end
end
