class Smrtanalysis < Formula
  desc "Analyze PacBio sequencing data"
  homepage "http://www.pacb.com/products-and-services/analytical-software/smrt-analysis/"
  # doi "10.1038/nmeth.2474"
  # tag "bioinformatics"
  url "https://s3.amazonaws.com/files.pacb.com/software/smrtanalysis/2.2.0/smrtanalysis-2.2.0.133377.run"
  sha256 "17ee0ebce5450a8dcd3d0cfc3cd0676de53c55f7894f642f136da645485a66be"

  bottle :unneeded

  # Patch
  resource "patch" do
    url "https://s3.amazonaws.com/files.pacb.com/software/smrtanalysis/2.2.0/smrtanalysis-2.2.0.133377-patch-3.run"
    sha256 "4c661f790103668eef073f40b73e589e0f455683b12ec91901e81d4c6adbc49d"
  end

  def install
    raise "SMRT Analysis cannot be installed on Mac OS" if OS.mac?
    system "sh", "./smrtanalysis-#{version}.run", "--extract-only",
      "--patchfile", resource("patch").cached_download,
      "--rootdir", prefix
  end

  test do
    system "#{prefix}/install/smrtanalysis-#{version}/analysis/bin/blasr"
  end
end
