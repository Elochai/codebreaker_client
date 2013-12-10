require './client'    
require 'codebreaker'      

  describe Client do  
    context "initially" do
      it "create output info" do
        expect(subject.output).to_not be_empty
      end
      it "set number of turns" do
        expect(subject.turns.to_s).to_not be_empty
      end
      it "set number of maded turns to zero" do
        expect(subject.turns_made).to eq(0)
      end
      it "set allow_hint var to 'true'" do
        expect(subject.allow_hint).to be_true
      end
      it "create new Guess object" do
        expect(subject.guess).to be_kind_of(Codebreaker::Guess)
      end
      it "create new Game object" do
        expect(subject.game).to be_kind_of(Codebreaker::Game)
      end
    end

    context "#start" do
      it "validate correctly generated code" do
        subject.game.code = "1234"
        allow(subject).to receive(:enter_command)
        expect {subject.start}.to_not raise_error
      end
      it "puts welcome message" do
        allow(subject).to receive(:print)
        expect(subject).to receive(:puts).with(subject.output[:welcome])
        subject.start
      end
      it "calls 'enter_command' method" do
        expect(subject).to receive(:print)
        subject.start
      end
      it "validate incorrect generated code and raise error" do
        subject.game.code = "16345"
        expect {subject.start}.to raise_error
      end
    end

    context "#print" do
      it "prints that you can enter command" do
        allow(subject).to receive(:enter_command)
        expect(subject).to receive(:puts).with(subject.output[:input])
        subject.print
      end
      it "calls 'enter_command' method" do
        expect(subject).to receive(:enter_command)
        subject.print
      end
      context "when called from 'enter_code' method" do
        before {subject.instance_variable_set(:@input_code,true)}
        it "prints that you can enter code" do
          allow(subject).to receive(:enter_code)
          expect(subject).to receive(:puts).with("Enter 4 numbers, each from 1 to 6 (#{subject.turns-subject.turns_made} turns remained):")
          subject.print
        end
        it "calls 'enter_code' method" do
          expect(subject).to receive(:enter_code)
          subject.print
        end
      end
    end

    context "#enter_command" do
      context "when typed 'guess'" do
        it "calls 'enter_code' method" do
          allow(subject).to receive(:gets).and_return("guess")
          expect(subject).to receive(:enter_code)
          subject.enter_command
        end
      end
      context "when typed 'hint'" do
        it "calls 'give_hint' method" do
          allow(subject).to receive(:gets).and_return("hint")
          allow(subject).to receive(:print)
          expect(subject).to receive(:give_hint)
          subject.enter_command
        end
      end
      context "when typed 'commands'" do
        it "shows commands" do
          allow(subject).to receive(:gets).and_return("commands")
          allow(subject).to receive(:print)
          expect(subject).to receive(:puts).with(subject.output[:commands])
          subject.enter_command
        end
      end
      context "when typed 'exit'" do
        it "closes application" do
          allow(subject).to receive(:gets).and_return("exit")
          expect(subject).to receive(:exit)
          subject.enter_command
        end
      end
      context "when typed anything else" do
        it "puts 'Wrong command!'" do
          allow(subject).to receive(:gets).and_return("asf")
          allow(subject).to receive(:print)
          expect(subject).to receive(:puts).with("Wrong command!")
          subject.enter_command
        end
      end
    end

    context "#enter_code" do
        context "when typed 'hint'" do
        it "calls 'give_hint' method" do
          allow(subject).to receive(:gets).and_return("hint")
          allow(subject).to receive(:print)
          expect(subject).to receive(:give_hint)
          subject.enter_code
        end
      end
      context "when typed 4 numbers from 1 to 6" do
        it "shows commands" do
          allow(subject).to receive(:gets).and_return("1234")
          expect(subject).to receive(:compare)
          subject.enter_code
        end
      end
      context "when typed 'exit'" do
        it "closes application" do
          allow(subject).to receive(:gets).and_return("exit")
          expect(subject).to receive(:exit)
          subject.enter_code
        end
      end
      context "when typed anything else" do
        it "asks again" do
          allow(subject).to receive(:gets).and_return("asf")
          expect(subject).to receive(:enter_code)
          subject.enter_code
        end
      end
    end

    context "#compare" do
      it "increases 'turns_made' var by 1" do
        subject.instance_variable_set(:@turns_made,0)
        allow(subject).to receive(:enter_code)
        subject.compare
        expect(subject.turns_made).to eq(1)
      end
      context "when player have turns" do
        it "calls 'enter_code' method" do
          expect(subject).to receive(:enter_code)
          subject.compare
        end
      end
      context "when player have no turns" do
        before {subject.instance_variable_set(:@turns_made,11)}
        it "tells that player lose and reveal the code" do
          allow(subject).to receive(:restart)
          allow(subject).to receive(:enter_code)
          expect(subject).to receive(:puts).with("You lose... The code was #{subject.game.code}")
          expect(subject).to receive(:puts).with([])
          subject.compare
        end
        it "calls 'restart' method" do
          expect(subject).to receive(:restart)
          subject.compare
        end
      end
      context "when player wins" do
        before {subject.instance_variable_set(:@turns_made,1)}
        it "tells that player win" do
          subject.game.code = "1234"
          subject.game.guess_code = "1234"
          allow(subject).to receive(:save)
          allow(subject).to receive(:enter_code)
          allow(subject).to receive(:restart)
          allow(subject).to receive(:puts).with(["+", "+", "+", "+"]) 
          expect(subject).to receive(:puts).with("Congrats, you win!") 
          subject.compare
        end
        it "calls 'save' method" do
          subject.game.code = "1234"
          subject.game.guess_code = "1234"
          allow(subject).to receive(:enter_code)
          allow(subject).to receive(:restart)
          expect(subject).to receive(:save)
          subject.compare
        end
        it "calls 'restart' method" do
          subject.game.code = "1234"
          subject.game.guess_code = "1234"
          allow(subject).to receive(:enter_code)
          expect(subject).to receive(:restart)
          subject.compare
        end
      end
    end

    context "#restart" do
      it "asks for continue to play" do
        allow(subject).to receive(:gets).and_return("y")
        allow(subject).to receive(:start)
        expect(subject).to receive(:puts).with("Do you want to play again? y/n")
        subject.restart
      end
      context "when typed 'y'" do
        it "sets 'allow_hint' var to 'true'" do
          subject.instance_variable_set(:@allow_hint,false)
          allow(subject).to receive(:gets).and_return("y")
          allow(subject).to receive(:start)
          subject.restart
          expect(subject.allow_hint).to eq(true)
        end
        it "sets 'turns_made' var to zero" do
          subject.instance_variable_set(:@turns_made,10)
          allow(subject).to receive(:gets).and_return("y")
          allow(subject).to receive(:start)
          subject.restart
          expect(subject.turns_made).to eq(0)
        end
        it "sets new 'Game' object" do
          old_game = subject.game
          allow(subject).to receive(:gets).and_return("y")
          allow(subject).to receive(:start)
          subject.restart
          expect(subject.game).to_not equal(old_game) 
        end
      end
      context "when typed 'n'" do
        it "closes application" do
          allow(subject).to receive(:gets).and_return("n")
          expect(subject).to receive(:exit)
          subject.restart
        end
      end
      context "when typed anything else" do
        it "asks again" do
          allow(subject).to receive(:gets).and_return("asf")
          expect(subject).to receive(:restart)
          subject.restart
        end
      end
    end

    context "#save" do
      it "asks to enter player's name" do
        allow(subject).to receive(:gets).and_return("Name")
        allow(subject).to receive(:puts).with("Game saved!")
        expect(subject).to receive(:puts).with("Enter your name")
        subject.send(:save)
      end
      it "saves info to file" do
        allow(subject).to receive(:gets).and_return("Name")
        allow(subject).to receive(:puts).with("Game saved!")
        expect(subject).to receive(:puts).with("Enter your name")
        file = double('file')
        expect(File).to receive(:open).with("./score.txt", 'a').and_yield(file)
        expect(file).to receive(:write).with(">> #{Time.now}\n player Name wins with #{subject.turns_made} turns.\n")
        expect(file).to receive(:close)
        subject.send(:save)
      end
    end

    context "#give_hint" do
      context "called first time" do
        it "set 'allow_hint' var to 'false'" do
          subject.instance_variable_set(:@allow_hint,true)
          subject.send(:give_hint)
          expect(subject.allow_hint).to eq(false) 
        end
        it "reveals one number to player" do
          subject.instance_variable_set(:@allow_hint,true)
          allow(subject.game).to receive(:give_hint).and_return("2")
          expect(subject).to receive(:puts).with("One of the numbers is 2, good luck ;)")
          subject.send(:give_hint)
        end
      end
      context "when called second time" do
        it "tells that player can't see hint" do
          subject.instance_variable_set(:@allow_hint,false)
          expect(subject).to receive(:puts).with("You have alredy used your hint")
          subject.send(:give_hint)
        end
      end
    end
  
  end