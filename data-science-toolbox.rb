require 'formula'

class DataScienceToolbox < Formula
  # See also http://jeroenjanssens.com/2013/09/19/seven-command-line-tools-for-data-science.html
  homepage 'https://github.com/jeroenjanssens/data-science-toolbox'
  version '077c94f'
  url "https://github.com/jeroenjanssens/data-science-toolbox/archive/#{version}.tar.gz"
  sha1 '35b4397f1d7356e833d923f446657219f58cb1c9'
  head 'https://github.com/jeroenjanssens/data-science-toolbox.git'

  def install
    bin.install Dir["tools/*"]
    doc.install 'README.md'
  end

  test do
    system 'Rio -h 2>&1 |grep -q Rio'
  end
end
