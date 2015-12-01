class Itsol < Formula
  homepage "http://www-users.cs.umn.edu/~saad/software/ITSOL"
  url "http://www-users.cs.umn.edu/~saad/software/ITSOL/ITSOL_2.tar.gz"
  sha256 "de8f2726e2dbc248e8ccebdbc9ce8515ad47a8c8595cca87264c22b44845736a"
  version "2.0"

  depends_on :fortran

  def install
    system "make"
    lib.install("LIB/libitsol.a")
    (include/"itsol").install Dir["INC/*.h"]
  end
end
