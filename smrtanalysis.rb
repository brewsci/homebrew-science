class Smrtanalysis < Formula
  homepage "http://www.pacb.com/devnet/"
  # doi "10.1038/nmeth.2474"
  url "https://s3.amazonaws.com/files.pacb.com/software/smrtanalysis/2.2.0/smrtanalysis-2.2.0.133377.run"
  sha256 "17ee0ebce5450a8dcd3d0cfc3cd0676de53c55f7894f642f136da645485a66be"

  # Patch
  # https://s3.amazonaws.com/files.pacb.com/software/smrtanalysis/2.2.0/smrtanalysis-2.2.0.133377-patch-1.run

  def install
    raise "SMRT Analysis cannot be installed on Mac OS" if OS.mac?
    system "sh ./smrtanalysis-#{version}.run --extract-only --rootdir #{prefix}"
  end

  test do
    system "#{prefix}/install/smrtanalysis-2.2.0.133377/analysis/bin/blasr"
  end
end
