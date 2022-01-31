 class Mytestpack < Formula
  desc ""
  homepage "https://www.paraview.org/"
  url "https://github.com/marcalexanderschweitzer/homebrew-science/blob/master/Formula/mytestpack-1.0.0.tar.gz?raw=true"
  sha256 ""

  depends_on "cmake"

def install
    args = std_cmake_args + %W[
      -DBUILD_TESTING:BOOL=OFF
      ]

      mkdir "build" do
        system "cmake", "..", *args
        system "make"
        system "make install"
      end

    #   bin.install_symlink Applications/paraview.app/Contents/MacOS/"paraview"
  end
end