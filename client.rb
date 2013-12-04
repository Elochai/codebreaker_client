require 'codebreaker'
class Client
  attr_accessor :turns_made, :hint
  attr_reader :turns, :game, :guess

  def initialize
    @output = {welcome: "Welcome to Codebreaker game!\nEnter command below:",
      commands: "Type 'guess' to enter your code\nType 'hint' to reveal one random number of secret code\n
      Type 'commands' to see all game commands\nType 'exit' or 'quit' to close this app"}
    @turns = 10
    @turns_made = 0
    @allow_hint = true
    @game = Codebreaker::Game.new 
    @guess = Codebreaker::Guess.new
  end

  def start
    if @game.valid?
      puts @output[:welcome]
      puts @game.code
      enter_command
    else
      raise "Invalid generated code. Game will be closed..."
    end
  end

  def enter_command
    command = gets
    case command
      when /^guess$/
        enter_code
      when /^hint$/
        give_hint
        enter_command
      when /^commands$/
        puts @output[:commands]
        enter_command
       when /^exit$|^quit$/
        exit
      else
        puts "Wrong command!"
        enter_command
    end
  end

  def enter_code
      puts "Enter 4 numbers, each from 1 to 6 (#{@turns-@turns_made} turns remained):"
      guess_code = gets
      case guess_code
        when /^exit$|^quit$/
          exit
        when /^hint$/
          give_hint
          enter_command
        when /^exit$|^quit$/
          exit
        else
          @game.guess(guess_code)
          compare
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
        start
      when /^n$|^no$/
        exit
      else
        puts "Can't understand"
        restart
      end
  end

  def save
    puts "Enter your name"
    name = gets
    File.open("./score.txt", 'a') do |file|
      file.write ">> #{Time.now}\n player #{name} wins with #{@turns_made} turns.\n"
      file.close
    end
    puts "Game saved!"
  end

  def give_hint
    if @allow_hint
      puts "One of numbers is #{@game.give_hint}, good luck ;)"
      @allow_hint = false
    else
      puts "You have alredy used your hint"
    end
  end

end
game = Client.new
puts game.start

