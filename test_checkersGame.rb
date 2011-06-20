require 'test/unit'
require 'checkersGame.rb'

class Test_checkersGame < Test::Unit::TestCase
	def test_BlackSquare
		#test a failure
		assert_raise(ArgumentError)\
			{mysquare=CheckersGame::BlackSquare.new('*',false)}
		#test correct initialization
		assert_nothing_raised(ArgumentError)\
			{mysquare=CheckersGame::BlackSquare.new(CheckersGame::BlackSquare::BLACK,false)}
		mysquare=CheckersGame::BlackSquare.new(CheckersGame::BlackSquare::BLACK,false)
		assert_equal(CheckersGame::BlackSquare::BLACK,mysquare.color)
		assert_equal(false,mysquare.kinged)
		assert_equal('Black',mysquare.to_s)
		assert_equal('b',mysquare.to_c)
	end
	def test_initialization
		mygame=CheckersGame.new
		assert_not_nil(mygame,'Failed to instantiate a game')
		assert_equal(CheckersGame::BlackSquare::BLACK,mygame.whose_turn,'Wrong initial player')
		assert_equal("  +---+---+---+---+---+---+---+---+\nh |   | r |   | r |   | r |   | r | \n  +---+---+---+---+---+---+---+---+\ng | r |   | r |   | r |   | r |   | \n  +---+---+---+---+---+---+---+---+\nf |   | r |   | r |   | r |   | r | \n  +---+---+---+---+---+---+---+---+\ne | . |   | . |   | . |   | . |   | \n  +---+---+---+---+---+---+---+---+\nd |   | . |   | . |   | . |   | . | \n  +---+---+---+---+---+---+---+---+\nc | b |   | b |   | b |   | b |   | \n  +---+---+---+---+---+---+---+---+\nb |   | b |   | b |   | b |   | b | \n  +---+---+---+---+---+---+---+---+\na | b |   | b |   | b |   | b |   | \n  +---+---+---+---+---+---+---+---+\n    1   2   3   4   5   6   7   8 \n",mygame.to_s)
		#Initially, the board should look like:
		#	  +---+---+---+---+---+---+---+---+
		#	h |   | r |   | r |   | r |   | r | 
		#	  +---+---+---+---+---+---+---+---+
		#	g | r |   | r |   | r |   | r |   | 
		#	  +---+---+---+---+---+---+---+---+
		#	f |   | r |   | r |   | r |   | r | 
		#	  +---+---+---+---+---+---+---+---+
		#	e | . |   | . |   | . |   | . |   | 
		#	  +---+---+---+---+---+---+---+---+
		#	d |   | . |   | . |   | . |   | . | 
		#	  +---+---+---+---+---+---+---+---+
		#	c | b |   | b |   | b |   | b |   | 
		#	  +---+---+---+---+---+---+---+---+
		#	b |   | b |   | b |   | b |   | b | 
		#	  +---+---+---+---+---+---+---+---+
		#	a | b |   | b |   | b |   | b |   | 
		#	  +---+---+---+---+---+---+---+---+
		#		1   2   3   4   5   6   7   8 
	end
	def test_first_legal_moves
		black_columns=%w[1 3 5 7]
		red_columns=%w[2 4 6 8]
		black_board_results=["  +---+---+---+---+---+---+---+---+\nh |   | r |   | r |   | r |   | r | \n  +---+---+---+---+---+---+---+---+\ng | r |   | r |   | r |   | r |   | \n  +---+---+---+---+---+---+---+---+\nf |   | r |   | r |   | r |   | r | \n  +---+---+---+---+---+---+---+---+\ne | . |   | . |   | . |   | . |   | \n  +---+---+---+---+---+---+---+---+\nd |   | b |   | . |   | . |   | . | \n  +---+---+---+---+---+---+---+---+\nc | . |   | b |   | b |   | b |   | \n  +---+---+---+---+---+---+---+---+\nb |   | b |   | b |   | b |   | b | \n  +---+---+---+---+---+---+---+---+\na | b |   | b |   | b |   | b |   | \n  +---+---+---+---+---+---+---+---+\n    1   2   3   4   5   6   7   8 \n", "  +---+---+---+---+---+---+---+---+\nh |   | r |   | r |   | r |   | r | \n  +---+---+---+---+---+---+---+---+\ng | r |   | r |   | r |   | r |   | \n  +---+---+---+---+---+---+---+---+\nf |   | r |   | r |   | r |   | r | \n  +---+---+---+---+---+---+---+---+\ne | . |   | . |   | . |   | . |   | \n  +---+---+---+---+---+---+---+---+\nd |   | . |   | b |   | . |   | . | \n  +---+---+---+---+---+---+---+---+\nc | b |   | . |   | b |   | b |   | \n  +---+---+---+---+---+---+---+---+\nb |   | b |   | b |   | b |   | b | \n  +---+---+---+---+---+---+---+---+\na | b |   | b |   | b |   | b |   | \n  +---+---+---+---+---+---+---+---+\n    1   2   3   4   5   6   7   8 \n", "  +---+---+---+---+---+---+---+---+\nh |   | r |   | r |   | r |   | r | \n  +---+---+---+---+---+---+---+---+\ng | r |   | r |   | r |   | r |   | \n  +---+---+---+---+---+---+---+---+\nf |   | r |   | r |   | r |   | r | \n  +---+---+---+---+---+---+---+---+\ne | . |   | . |   | . |   | . |   | \n  +---+---+---+---+---+---+---+---+\nd |   | . |   | . |   | b |   | . | \n  +---+---+---+---+---+---+---+---+\nc | b |   | b |   | . |   | b |   | \n  +---+---+---+---+---+---+---+---+\nb |   | b |   | b |   | b |   | b | \n  +---+---+---+---+---+---+---+---+\na | b |   | b |   | b |   | b |   | \n  +---+---+---+---+---+---+---+---+\n    1   2   3   4   5   6   7   8 \n", "  +---+---+---+---+---+---+---+---+\nh |   | r |   | r |   | r |   | r | \n  +---+---+---+---+---+---+---+---+\ng | r |   | r |   | r |   | r |   | \n  +---+---+---+---+---+---+---+---+\nf |   | r |   | r |   | r |   | r | \n  +---+---+---+---+---+---+---+---+\ne | . |   | . |   | . |   | . |   | \n  +---+---+---+---+---+---+---+---+\nd |   | . |   | . |   | . |   | b | \n  +---+---+---+---+---+---+---+---+\nc | b |   | b |   | b |   | . |   | \n  +---+---+---+---+---+---+---+---+\nb |   | b |   | b |   | b |   | b | \n  +---+---+---+---+---+---+---+---+\na | b |   | b |   | b |   | b |   | \n  +---+---+---+---+---+---+---+---+\n    1   2   3   4   5   6   7   8 \n"]
		#Test some initial moves for Black
		for i in 0...4
			mygame=CheckersGame.new
			assert_equal(0,mygame.move('c'+black_columns[i],'d'+String(Integer(black_columns[i])+1)))
			assert_equal(CheckersGame::BlackSquare::RED,mygame.whose_turn)
			assert_equal(black_board_results[i],mygame.to_s)
		end
		#Test some counter moves for Red for one of the black openings
		red_board_results=["  +---+---+---+---+---+---+---+---+\nh |   | r |   | r |   | r |   | r | \n  +---+---+---+---+---+---+---+---+\ng | r |   | r |   | r |   | r |   | \n  +---+---+---+---+---+---+---+---+\nf |   | . |   | r |   | r |   | r | \n  +---+---+---+---+---+---+---+---+\ne | r |   | . |   | . |   | . |   | \n  +---+---+---+---+---+---+---+---+\nd |   | . |   | b |   | . |   | . | \n  +---+---+---+---+---+---+---+---+\nc | b |   | . |   | b |   | b |   | \n  +---+---+---+---+---+---+---+---+\nb |   | b |   | b |   | b |   | b | \n  +---+---+---+---+---+---+---+---+\na | b |   | b |   | b |   | b |   | \n  +---+---+---+---+---+---+---+---+\n    1   2   3   4   5   6   7   8 \n", "  +---+---+---+---+---+---+---+---+\nh |   | r |   | r |   | r |   | r | \n  +---+---+---+---+---+---+---+---+\ng | r |   | r |   | r |   | r |   | \n  +---+---+---+---+---+---+---+---+\nf |   | r |   | . |   | r |   | r | \n  +---+---+---+---+---+---+---+---+\ne | . |   | r |   | . |   | . |   | \n  +---+---+---+---+---+---+---+---+\nd |   | . |   | b |   | . |   | . | \n  +---+---+---+---+---+---+---+---+\nc | b |   | . |   | b |   | b |   | \n  +---+---+---+---+---+---+---+---+\nb |   | b |   | b |   | b |   | b | \n  +---+---+---+---+---+---+---+---+\na | b |   | b |   | b |   | b |   | \n  +---+---+---+---+---+---+---+---+\n    1   2   3   4   5   6   7   8 \n", "  +---+---+---+---+---+---+---+---+\nh |   | r |   | r |   | r |   | r | \n  +---+---+---+---+---+---+---+---+\ng | r |   | r |   | r |   | r |   | \n  +---+---+---+---+---+---+---+---+\nf |   | r |   | r |   | . |   | r | \n  +---+---+---+---+---+---+---+---+\ne | . |   | . |   | r |   | . |   | \n  +---+---+---+---+---+---+---+---+\nd |   | . |   | b |   | . |   | . | \n  +---+---+---+---+---+---+---+---+\nc | b |   | . |   | b |   | b |   | \n  +---+---+---+---+---+---+---+---+\nb |   | b |   | b |   | b |   | b | \n  +---+---+---+---+---+---+---+---+\na | b |   | b |   | b |   | b |   | \n  +---+---+---+---+---+---+---+---+\n    1   2   3   4   5   6   7   8 \n", "  +---+---+---+---+---+---+---+---+\nh |   | r |   | r |   | r |   | r | \n  +---+---+---+---+---+---+---+---+\ng | r |   | r |   | r |   | r |   | \n  +---+---+---+---+---+---+---+---+\nf |   | r |   | r |   | r |   | . | \n  +---+---+---+---+---+---+---+---+\ne | . |   | . |   | . |   | r |   | \n  +---+---+---+---+---+---+---+---+\nd |   | . |   | b |   | . |   | . | \n  +---+---+---+---+---+---+---+---+\nc | b |   | . |   | b |   | b |   | \n  +---+---+---+---+---+---+---+---+\nb |   | b |   | b |   | b |   | b | \n  +---+---+---+---+---+---+---+---+\na | b |   | b |   | b |   | b |   | \n  +---+---+---+---+---+---+---+---+\n    1   2   3   4   5   6   7   8 \n"]
		for i in 0...4
			mygame=CheckersGame.new
			mygame.move('c3','d4')
			#Game now looks like:
			#  +---+---+---+---+---+---+---+---+
			#h |   | r |   | r |   | r |   | r | 
			#  +---+---+---+---+---+---+---+---+
			#g | r |   | r |   | r |   | r |   | 
			#  +---+---+---+---+---+---+---+---+
			#f |   | r |   | r |   | r |   | r | 
			#  +---+---+---+---+---+---+---+---+
			#e | . |   | . |   | . |   | . |   | 
			#  +---+---+---+---+---+---+---+---+
			#d |   | . |   | b |   | . |   | . | 
			#  +---+---+---+---+---+---+---+---+
			#c | b |   | . |   | b |   | b |   | 
			#  +---+---+---+---+---+---+---+---+
			#b |   | b |   | b |   | b |   | b | 
			#  +---+---+---+---+---+---+---+---+
			#a | b |   | b |   | b |   | b |   | 
			#  +---+---+---+---+---+---+---+---+
			#    1   2   3   4   5   6   7   8 

			assert_equal(0,mygame.move('f'+red_columns[i],'e'+String(Integer(red_columns[i])-1)))
			assert_equal(CheckersGame::BlackSquare::BLACK,mygame.whose_turn)
			assert_equal(mygame.to_s,red_board_results[i])
		end
	end
	def test_indexing
		mygame=CheckersGame.new
		#test incorrect coordinates labels
		#first label illegal
		assert_raise(IndexError){mygame['*','2']}
		#second label illegal
		assert_raise(IndexError){mygame['a','*']}
		#both labels illegal
		assert_raise(IndexError){mygame['*','*']}
		
		#test each square
		init_gameboard=[	["b", nil, "b", nil, "b", nil, "b", nil], \
							[nil, "b", nil, "b", nil, "b", nil, "b"], \
							["b", nil, "b", nil, "b", nil, "b", nil], \
							[nil, ".", nil, ".", nil, ".", nil, "."], \
							[".", nil, ".", nil, ".", nil, ".", nil], \
							[nil, "r", nil, "r", nil, "r", nil, "r"], \
							["r", nil, "r", nil, "r", nil, "r", nil], \
							[nil, "r", nil, "r", nil, "r", nil, "r"]]
		row_labels=CheckersGame::ROW_LOOKUP.keys.sort
		column_labels=CheckersGame::COLUMN_LOOKUP.keys.sort
		for i in 0...8
			for j in 0...8
				if (init_gameboard[i][j])
					assert_equal(init_gameboard[i][j],mygame[row_labels[i],column_labels[j]].to_c)
				else
					assert_nil(mygame[row_labels[i],column_labels[j]])
				end
			end
		end
	end
	def test_erroneous_moves
		#test coordinate legality testing
		#neither illegal
		assert_equal(0,CheckersGame.new.move('c1','d2'))
		#one illegal
		mygame=CheckersGame.new
		assert_equal(1,mygame.move('*1','d2'))
		assert_equal(CheckersGame::BlackSquare::BLACK,mygame.whose_turn)
		mygame=CheckersGame.new
		assert_equal(1,mygame.move('c*','d2'))
		assert_equal(CheckersGame::BlackSquare::BLACK,mygame.whose_turn)
		mygame=CheckersGame.new
		assert_equal(4,mygame.move('c1','*2'))
		assert_equal(CheckersGame::BlackSquare::BLACK,mygame.whose_turn)
		mygame=CheckersGame.new
		assert_equal(4,mygame.move('c1','d*'))
		assert_equal(CheckersGame::BlackSquare::BLACK,mygame.whose_turn)
		#both illegal
		mygame=CheckersGame.new
		assert_equal(5,mygame.move('c*','d*'))
		assert_equal(CheckersGame::BlackSquare::BLACK,mygame.whose_turn)
		
		#test testing for playing only on black squares
		#From coordinates:
		for i in 1..8
			mygame=CheckersGame.new
			assert_equal(((i-1)%2),(mygame.move('c'+String(i),'d4')>>1)%2)
			if((i-1)%2==1)
				assert_equal(CheckersGame::BlackSquare::BLACK,mygame.whose_turn)
			end
		end
		#To coordinates:
		for i in 1..8
			mygame=CheckersGame.new
			assert_equal((i%2),(mygame.move('c1','d'+String(i))>>3)%2)
			if(i%2==1)
				assert_equal(CheckersGame::BlackSquare::BLACK,mygame.whose_turn)
			end
		end
		#Both coordinates:
		for i in 1..7
			mygame=CheckersGame.new
			assert_equal(10*((i-1)%2),mygame.move('c'+String(i),'d'+String(i+1)))
			if((i-1)%2==1)
				assert_equal(CheckersGame::BlackSquare::BLACK,mygame.whose_turn)
			end
		end
		
		#Test testing that From coordinates contain player's piece
		#Contains correct color
		mygame=CheckersGame.new
		assert_equal(0,(mygame.move('c5','d6')>>4)%2)
		#Contains other player's color
		mygame=CheckersGame.new
		assert_equal(1,(mygame.move('f4','e5')>>4)%2)
		assert_equal(CheckersGame::BlackSquare::BLACK,mygame.whose_turn)
		#Square is blank
		mygame=CheckersGame.new
		assert_equal(1,(mygame.move('d6','e7')>>4)%2)
		assert_equal(CheckersGame::BlackSquare::BLACK,mygame.whose_turn)
		
		#Test testing that To coordinates are unoccupied
		#Unoccupied case:
		mygame=CheckersGame.new
		assert_equal(0,mygame.move('c1','d2'))
		assert_equal(CheckersGame::BlackSquare::RED,mygame.whose_turn)
		assert_equal(0,mygame.move('f4','e3'))
		assert_equal(CheckersGame::BlackSquare::BLACK,mygame.whose_turn)
		#Trying to move to a space occupied by opponent
		assert_equal(1,(mygame.move('d2','e3')>>5)%2)
		assert_equal(CheckersGame::BlackSquare::BLACK,mygame.whose_turn)
		#Trying to move to a space occupied by self
		assert_equal(1,(mygame.move('c3','d2')>>5)%2)
		assert_equal(CheckersGame::BlackSquare::BLACK,mygame.whose_turn)
		
		#Test testing move legality
		#We've already had plenty of positive cases go through
		#Here are some negative cases
		mygame=CheckersGame.new
		assert_equal(64,mygame.move('c1','e3'))
		assert_equal(64,mygame.move('c3','d6'))
		assert_equal(64,mygame.move('c5','e5'))
		assert_equal(64,mygame.move('c7','d2'))
		
	end
end