require './client'    
require 'codebreaker'      

  describe Client do  
    context "initially" do
      it "should create output info" do
        expect(subject.output).to_not be_empty
      end
      it "should set number of turns" do
        expect(subject.turns.to_s).to_not be_empty
      end
      it "should set number of maded turns to zero" do
        expect(subject.turns_made).to eq(0)
      end
      it "should set allow_hint var to 'true'" do
        expect(subject.allow_hint).to be_true
      end
      it "should create new Guess object" do
        expect(subject.guess).to be_kind_of(Codebreaker::Guess)
      end
      it "should create new Game object" do
        expect(subject.game).to be_kind_of(Codebreaker::Game)
      end
    end

    context "start" do
      it "should validate correctly generated code"
        
    end
  
  end