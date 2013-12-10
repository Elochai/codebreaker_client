require 'codebreaker'
class Client
  attr_accessor :output
  attr_reader :turns, :game, :guess, :input_code, :allow_hint, :turns_made

  def initialize
    @output = {welcome: "Welcome to Codebreaker game!",
      input: "Enter command below:",
      commands: "Type 'guess' to enter your code\nType 'hint' to reveal one random number of secret code\nType 'commands' to see all game commands\nType 'exit' or 'quit' to close this app"}
    @turns = 10
    @turns_made = 0
    @allow_hint = true
    @input_code = false
    @game = Codebreaker::Game.new 
    @guess = Codebreaker::Guess.new
    puts @output[:welcome]
  end

  def start
    if @game.valid?
      puts @output[:welcome]
      print
    else
      raise "Invalid generated code. Game will be closed..."
    end
  end

  def print
    if @input_code
        puts "Enter 4 numbers, each from 1 to 6 (#{@turns-@turns_made} turns remained):"
        enter_code
      else
        puts @output[:input]
        enter_command
      end
  end

  def enter_command
    command = gets
    case command
      when /^guess$/
        @input_code = true
        print
      when /^hint$/
        give_hint
        print
      when /^commands$/
        puts @output[:commands]
        print
       when /^exit$|^quit$/
        exit
      else
        puts "Wrong command!"
        print
    end
  end

  def enter_code
      guess_code = gets
      case guess_code
        when /^exit$|^quit$/
          exit
        when /^hint$/
          give_hint
          print
        when /^[1-6]{4}$/
          @game.guess_code = guess_code
          compare
        else
          puts "Can't understand..."
          print
      end
  end

  def compare
    @turns_made+=1
    puts @game.compare
    if @game.compare == ["+","+","+","+"]
      puts "Congrats, you win!"
      save
      restart
    end
    if @turns_made < @turns
      enter_code
    else
      puts "You lose... The code was #{@game.code}"
      restart
    end
  end

  def restart
    puts "Do you want to play again? y/n"
    desicion = gets
    case desicion
      when /^y$|^yes$/
        @game = Codebreaker::Game.new 
        @turns_made = 0
        @allow_hint = true
        @from_enter_code = false
        start
      when /^n$|^no$/
        exit
      else
        puts "Can't understand..."
        restart
      end
  end

  private
  def save
    puts "Enter your name"
    name = gets
    File.open("./score.txt", 'a') do |file|
      file.write ">> #{Time.now}\n player #{name} wins with #{@turns_made} turns.\n"
      file.close
    end
    puts "Game saved!"
  end

  private
  def give_hint
    if @allow_hint
      puts "One of the numbers is #{@game.give_hint}, good luck ;)"
      @allow_hint = false
    else
      puts "You have alredy used your hint"
    end
  end
end


