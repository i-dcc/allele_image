# This is a small extension to the Array class to allow you
# to sum the elements of an array of numbers
#
# Taken from http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/61950
class Array
  def sum
    self.reduce do |a,b|
      a + b
    end
  end
end