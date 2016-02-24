#Yiran Zheng
#zhengyr@brandeis.edu
#cosi166b_zhengyr
#this is the class for node to backtrack the path we went
class Node
  attr_accessor :parent, :x, :y
  def initialize(p, nx, ny)
    @parent = p
    @x = nx
    @y = ny
  end
end