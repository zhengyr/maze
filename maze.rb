#Yiran Zheng
#zhengyr@brandeis.edu
#cosi166b
#this is the class for maze
require_relative "Node"
class Maze
  attr_accessor :maze_mat, :n, :m, :r, :c, :marker
  #this is the constructor for maze
  def initialize (n, m)
    @r = m
    @c = n
    @n = m * 2 + 1
    @m = n * 2 + 1
    @maze_mat = Array.new(@n){Array.new(@m)}
  end
  #this method will load a sepcific maze
  def load(s)
    c = 0
    n.times do |i|
      m.times do |j|
        maze_mat[i][j] = s[c].to_i
        c += 1
      end
    end
  end
  #this method will display the maze using chars
  def display
    #if the user haven't load the maze
    if maze_mat[0][0].nil?
      puts "empty maze! please load a maze!"
      return
    end
    n.times do |i|
      m.times do |j|
        if i % 2 == 0 && j % 2 == 1
          print_char(i, j, "-")
        elsif i % 2 == 1 && j % 2 == 1
          print_char(i, j, " ")
        elsif i % 2 == 1 && j % 2 == 0
          print_char(i, j, "|")
        else
          print"+"
        end
      end
      puts
    end
  end
  #this method will print chars according to the number in the array
  def print_char (i, j, s)
    if maze_mat[i][j] == 1
      print s
    else
      print " "
    end
  end
  #this method translte the position given to the position in the matrix
  def position_translate(i)
    i * 2 + 1
  end
  #this position decide if there is a position from beg position to end position
  def solve (bx, by, ex, ey)
    @marker = Array.new(r){Array.new(c){false}}
    @result = [false, nil]
    @beg = Node.new(nil, bx, by)
    dfs_solve(bx, by, ex, ey, @beg).to_s
    @result[0]
  end
  #this method is the depth first search find if there is a path from beg position to end position
  def dfs_solve(bx, by, ex, ey, n)
    if bx == ex and by == ey
      @result[0] = true
      @result[1] = n
    else
      if marker[by][bx] == false
        marker[by][bx] = true
        adj_pos = generate_adj_pos(bx, by)
        adj_pos.each do |pos|
          node = Node.new(n, pos[0], pos[1])
          dfs_solve(pos[0], pos[1], ex, ey, node)
        end
      end
    end
  end
  #this method would trace the
  def trace (begX, begY, endX, endY)
    solve(begX, begY, endX, endY)
    if @result[0] == false
      puts "No valid Path"
    else
      result_trace(@result[1])
    end
  end
  def result_trace(n)
    if n.parent == nil
      puts [n.x, n.y].to_s
    else
      result_trace(n.parent)
      puts [n.x, n.y].to_s
    end
  end
  #this method is generating a list of point that is adj to given point
  def generate_adj_pos (x, y)
    adj_pos = Array.new()
    top_y = position_translate(y) - 1
    bottom_y = top_y + 2
    left_x = position_translate(x) - 1
    right_x = left_x + 2
    new_x = position_translate(x)
    new_y = position_translate(y)
    if valid_edge(top_y, new_x)
      adj_pos.push([x , y - 1])
    end
    if valid_edge(bottom_y, new_x)
      adj_pos.push([x, y + 1])
    end
    if valid_edge(new_y, left_x)
      adj_pos.push([x - 1, y])
    end
    if valid_edge(new_y, right_x)
      adj_pos.push([x + 1, y])
    end
    return adj_pos
  end
  #this method is checking if there is a connection at the specific point
  def valid_edge(x, y)
    if x < m and x > 0 and y < n and y > 0 and maze_mat[x][y] == 0
      return true
    end
    false
  end
  #this method is redesign the given matrix
  def redesign
    reset_mat
    recur_divide(0, 0, m, n, cut_dir(c, r))
  end
  #this is the recursive divide algorithm for redesigning our maze
  #this method could be cutted into small piece but I feel like it's easier to see it this way
  #I read about this algorithm online as one of the maze generation algorithms
  #the main idea of this algorithm is that each iteration we cut the maze into two pieces until the size is
  #too small and we are unable to cut it
  def recur_divide(x, y, w, h, dir)
    #we first check the size of our given part of the maze
    if w >= 5 and h >= 5
      #then we set where we want to add the wall in the maze
      check_h_cut = dir == "H_cut"
      c = (w-1)/2
      wall_x = x + (check_h_cut ? 1 : (rand(c - 1)+1)*2)
      r = (h-1)/2
      wall_y = y + (check_h_cut ? (rand(r - 1)+1)*2 : 1)

      #the incrementing number for maze
      incre_x = check_h_cut ? 2 : 0
      incre_y = check_h_cut ? 0 : 2

      #every time we break the maze into two part, we need to leave a hole in
      #the wall so that we could enter from one part to the other
      hole_x = wall_x + (check_h_cut ? rand(c)*2 : 0)
      hole_y = wall_y + (check_h_cut ? 0 : rand(r)*2)
      wall_length = check_h_cut ? c : r

      #draw the wall here
      wall_length.times do
        if wall_x != hole_x || wall_y != hole_y
          maze_mat[wall_y][wall_x] = 1
        end
        wall_x += incre_x
        wall_y += incre_y
      end

      #recirsively divide the maze into two parts and then draw the wall the the two parts
      new_x = x
      new_y = y
      new_w = check_h_cut ? w : wall_x - x + 1
      new_h = check_h_cut ? wall_y - y + 1 : h
      recur_divide(new_x, new_y, new_w, new_h, cut_dir(new_w, new_h)) #this is the top/left part of the maze
      new_x = check_h_cut ? x : wall_x
      new_y = check_h_cut ? wall_y : y
      new_w = check_h_cut ? w : w - wall_x + x
      new_h = check_h_cut ? h - wall_y + y : h
      recur_divide(new_x, new_y, new_w, new_h, cut_dir(new_w, new_h)) #this is the bottom/right part of the maze
    end
  end
  #this is the method which decide how we should cut the maze
  def cut_dir (w, h)
    if w < h
      return "H_cut"
    elsif w > h
      return "V_cut"
    else
      if rand(2) == 0
        return "V_cut"
      else
        return "H_cut"
      end
    end
  end
  #this method reset the given maze to an empty maze
  def reset_mat
    for i in 1..(n-2)
      for j in 1..(m-2)
        if i % 2 == 1 and j % 2 == 0
          maze_mat[i][j] = 0
        elsif i % 2 == 0 and j % 2 == 1
          maze_mat[i][j] = 0
        end
      end
    end
  end
end
#this is the initialization of maze
m = Maze.new(4,5)
#puts "Finished initialization of the maze"
#this is the loading of maze
#m.load("111111111100010001111010101100010101101110101100000101111011101100000101111111111111111111111111111")
#puts "Finished loading of the maze"
m.display
#puts "solve for (0, 4) to (3, 3): " + m.solve(0, 4, 3, 3).to_s
#puts "the tracing result for (0, 4) to (3, 3): "
#m.trace(0, 4, 3, 3)
#puts "redesign the matrix"
#m.redesign
#m.display
