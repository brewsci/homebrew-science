require 'formula'

class Spades < Formula
  homepage "http://bioinf.spbau.ru/spades/"
  #tag "bioinformatics"
  #doi "10.1089/cmb.2012.0021"

  url "http://spades.bioinf.spbau.ru/release3.5.0/SPAdes-3.5.0.tar.gz"
  sha1 "cca0dde2acb21854e9a87b0ace9ac3e08da55202"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "9a1c20f1088872cc813d160f6bdf9e62b2670818" => :yosemite
    sha1 "c379f3bfdce510a95fb5fd4b6a5678988c48b77a" => :mavericks
    sha1 "92f6aba80bc8b969ffb30a5360db77da5be8e860" => :mountain_lion
  end

  depends_on 'cmake' => :build

  def install
    mkdir 'src/build' do
      system 'cmake', '..', *std_cmake_args
      system 'make', 'install'
    end

    # Fix the audit error "Non-executables were installed to bin"
    inreplace bin/"spades_init.py" do |s|
      s.sub! /^/, "#!/usr/bin/env python\n"
    end
  end

  test do
    system "spades.py", "--test"
    rm bin/"spades_init.pyc"
  end
end
