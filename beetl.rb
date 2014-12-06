require 'formula'

class Beetl < Formula
  homepage 'https://github.com/BEETL/BEETL'
  url 'https://github.com/BEETL/BEETL/archive/BEETL-0.9.0.tar.gz'
  sha1 '545e23e8132af297a6c39c10410a0d0ca392b38c'

  depends_on 'boost' => :optional
  depends_on 'seqan' => :optional

  needs :cxx11
  needs :openmp

  patch do
    # Include necessary headers
    url "https://github.com/sjackman/BEETL/commit/c91ad73.diff"
    sha1 "6aca0f9a045e8831b15b050691a3ce1d5cd3609d"
  end

  def install
    boost = Formula["boost"].opt_prefix
    seqan = Formula["seqan"].opt_prefix/'include'
    args = [
      '--disable-dependency-tracking',
      '--disable-silent-rules',
      "--prefix=#{prefix}"]
    args << "--with-boost=#{boost}" if build.with? 'boost'
    args << "--with-seqan=#{seqan}" if build.with? 'seqan'
    system './configure', *args
    system 'make', 'install'
  end

  test do
    system 'beetl --version'
  end
end
