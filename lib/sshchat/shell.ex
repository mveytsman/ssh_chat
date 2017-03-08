require IEx;
defmodule SSHChat.Shell do
  def hello do
    "HI"
  end

  def start do
    
    IO.puts("MY NAME IS MAX")
    spawn_link &start_loop/0
  end

  def start_loop do
   IEx.pry 
    IO.puts("MY NAME IS MAX")
    
    start_loop()
  end

end
