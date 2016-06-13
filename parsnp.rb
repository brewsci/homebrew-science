class Parsnp < Formula
  desc "Microbial core genome alignment and SNP detection"
  homepage "https://github.com/marbl/parsnp"
  # tag "bioinformatics"
  # doi "10.1186/s13059-014-0524-x"
  head "https://github.com/marbl/parsnp.git"

  if OS.mac?
    url "https://github.com/marbl/parsnp/releases/download/v1.2/parsnp-OSX64-v1.2.tar.gz"
    sha256 "fe8992fb148541cc753670a151bab9ccbd62a23bdec8be9a9c69999e3ca9ff02"
  elsif OS.linux?
    url "https://github.com/marbl/parsnp/releases/download/v1.2/parsnp-Linux64-v1.2.tar.gz"
    sha256 "ec60bab2306005baca374cc84b4d4dd20dd124e7ea0eee88ec59d9e5a95ce548"
  end

  bottle :unneeded

  def install
    bin.install "parsnp"
    doc.install "README"
  end

  test do
    assert_match "recombination", shell_output("#{bin}/parsnp 2>&1", 2)
  end
end
