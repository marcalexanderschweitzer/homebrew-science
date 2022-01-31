 class Mytestpack < Formula
  desc ""
  homepage "https://www.paraview.org/"
  url "https://github.com/marcalexanderschweitzer/homebrew-science/blob/master/Formula/mytestpack-1.0.tar.gz?raw=true"
  sha256 "f30e414c9b73c7b41c75d0ba05e26772fe567c40cc8423822272fd45263460f4"

  depends_on "cmake"

def install
    args = std_cmake_args + %W[
      -DBUILD_TESTING:BOOL=OFF
      ]

      mkdir "build" do
        system "cmake", "..", *args
        system "make"
        # system "make install"
        bin.install "build/solver" => "build_mysolver"
        bin.install "solver" => "mysolver"
    end

    #   bin.install_symlink "mysolver"
    end
end