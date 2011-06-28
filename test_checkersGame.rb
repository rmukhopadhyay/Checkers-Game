require 'test/unit'
require 'checkersGame.rb'

class Test_checkersGame < Test::Unit::TestCase
	def test_Square_error
		#test a failure
		assert_raise(ArgumentError)\
			{mysquare=CheckersGame::Square.new('*',false)}
	end
	def test_Square_initialization
		#test correct initialization
		assert_nothing_raised(ArgumentError)\
			{mysquare=CheckersGame::Square.new(CheckersGame::Square::BLACK,false)}
		mysquare=CheckersGame::Square.new(CheckersGame::Square::BLACK,false)
		assert_equal(CheckersGame::Square::BLACK,mysquare.color)
		assert_equal(false,mysquare.kinged)
		assert_equal('Black',mysquare.to_s)
		assert_equal('b',mysquare.to_c)
	end
	#test test to_s
	def test_to_s
		mygame=CheckersGame.new
		assert_not_nil(mygame,'Failed to instantiate a game')
		assert_equal(\
			"  +---+---+---+---+---+---+---+---+\n"+\
			"h |   | r |   | r |   | r |   | r | \n"+\
			"  +---+---+---+---+---+---+---+---+\n"+\
			"g | r |   | r |   | r |   | r |   | \n"+\
			"  +---+---+---+---+---+---+---+---+\n"+\
			"f |   | r |   | r |   | r |   | r | \n"+\
			"  +---+---+---+---+---+---+---+---+\n"+\
			"e | . |   | . |   | . |   | . |   | \n"+\
			"  +---+---+---+---+---+---+---+---+\n"+\
			"d |   | . |   | . |   | . |   | . | \n"+\
			"  +---+---+---+---+---+---+---+---+\n"+\
			"c | b |   | b |   | b |   | b |   | \n"+\
			"  +---+---+---+---+---+---+---+---+\n"+\
			"b |   | b |   | b |   | b |   | b | \n"+\
			"  +---+---+---+---+---+---+---+---+\n"+\
			"a | b |   | b |   | b |   | b |   | \n"+\
			"  +---+---+---+---+---+---+---+---+\n"+\
			"    1   2   3   4   5   6   7   8 \n",mygame.to_s)
	end
	#test [] operator.  
	def test_indexing_errors
		mygame=CheckersGame.new
		#test incorrect coordinates labels
		#first label illegal
		assert_raise(IndexError){mygame['*','2']}
		#second label illegal
		assert_raise(IndexError){mygame['a','*']}
		#both labels illegal
		assert_raise(IndexError){mygame['*','*']}
	end
	def test_indexing
		#test each square
		mygame=CheckersGame.new
		b=CheckersGame::Square::BLACK
		r=CheckersGame::Square::RED
		x=CheckersGame::Square::BLANK
		init_gameboard=[	[b, nil, b, nil, b, nil, b, nil], \
							[nil, b, nil, b, nil, b, nil, b], \
							[b, nil, b, nil, b, nil, b, nil], \
							[nil, x, nil, x, nil, x, nil, x], \
							[x, nil, x, nil, x, nil, x, nil], \
							[nil, r, nil, r, nil, r, nil, r], \
							[r, nil, r, nil, r, nil, r, nil], \
							[nil, r, nil, r, nil, r, nil, r]]
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
	
	def test_equality
		assert_equal(CheckersGame.new,CheckersGame.new)
	end
	def test_inequality
		mygame=CheckersGame.new
		mygame.move('c3','d4')
		assert_not_equal(CheckersGame.new,mygame)
	end
	def test_remove
		assert_equal(CheckersGame::Square::BLANK,CheckersGame.new.remove('c','3')['c','3'].color)
	end
	def test_place
		assert_equal(CheckersGame::Square::RED,\
			CheckersGame.new.place('c','3',CheckersGame::Square::RED,false)['c','3'].color)
	end
	#Since remove is just a call to place, this tests errors for both functions
	def test_remove_errors
		#test error case
		assert_raise(IndexError){CheckersGame.new.remove('c','*')}
		assert_raise(IndexError){CheckersGame.new.remove('*','3')}
	end
	def test_first_legal_moves_black
		black_columns=%w[1 3 5 7]
		#Test some initial moves for Black
		for i in 0...4
			mygame=CheckersGame.new
			assert_equal(\
				CheckersGame.new.remove('c',black_columns[i]).\
				place('d',String(Integer(black_columns[i])+1),\
				CheckersGame::Square::BLACK,false).toggle_turn,\
				mygame.move('c'+black_columns[i],'d'+String(Integer(black_columns[i])+1)))
		end
	end
	#Test some counter moves for Red for one of the black openings
	def test_first_legal_moves_red
		red_columns=%w[2 4 6 8]
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

			
			assert_equal(\
				CheckersGame.new.move('c3','d4').remove('f',red_columns[i]).\
				place('e',String(Integer(red_columns[i])-1),\
				CheckersGame::Square::RED,false).toggle_turn,\
				mygame.move('f'+red_columns[i],'e'+String(Integer(red_columns[i])-1)))
		end
	end
	#test coordinate legality testing
	def test_erroneous_moves_IndexError_1
		#neither illegal
		assert_nothing_raised(IndexError,ArgumentError){CheckersGame.new.move('c1','d2')}
	end
	def test_erroneous_moves_IndexError_2
		mygame=CheckersGame.new
		assert_raise(IndexError){mygame.move('*1','d2')}
		assert_equal(CheckersGame.new,mygame)
	end
	def test_erroneous_moves_IndexError_3
		mygame=CheckersGame.new
		assert_raise(IndexError){mygame.move('c*','d2')}
		assert_equal(CheckersGame.new,mygame)
	end
	def test_erroneous_moves_IndexError_4
		mygame=CheckersGame.new
		assert_raise(IndexError){mygame.move('c1','*2')}
		assert_equal(CheckersGame.new(),mygame)
	end
	def test_erroneous_moves_IndexError_5
		mygame=CheckersGame.new
		assert_raise(IndexError){mygame.move('c1','d*')}
		assert_equal(CheckersGame.new,mygame)
	end
	def test_erroneous_moves_IndexError_6
		#both illegal
		mygame=CheckersGame.new
		assert_raise(IndexError){mygame.move('c*','d*')}
		assert_equal(CheckersGame.new,mygame)
	end
	def test_erroneous_moves_IndexError_7
		#test testing for playing only on black squares
		#From coordinates:
		mygame=CheckersGame.new
		for i in 1..8
			if((i-1)%2==1)
				assert_raise(IndexError){mygame.move('c'+String(i),'d4')}
				assert_equal(CheckersGame.new,mygame)
			end
		end
	end
	def test_erroneous_moves_IndexError_8
		#test testing for playing only on black squares
		#To coordinates:
		for i in 1..8
			mygame=CheckersGame.new
			if(i%2==1)
				assert_raise(IndexError){mygame.move('c1','d'+String(i))}
				assert_equal(CheckersGame.new,mygame)
			end
		end
	end
	def test_erroneous_moves_IndexError_9
		#test testing for playing only on black squares
		#Both coordinates:
		for i in 1..7
			mygame=CheckersGame.new
			if((i-1)%2==1)
				assert_raise(IndexError){mygame.move('c'+String(i),'d'+String(i+1))}
				assert_equal(CheckersGame.new,mygame)
			end
		end
	end
	def test_erroneous_moves_ArgumentError_1
		#Test testing that From coordinates contain player's piece
		#Contains correct color
		mygame=CheckersGame.new
		assert_nothing_raised(ArgumentError){mygame.move('c5','d6')}
		assert_equal(CheckersGame.new.remove('c','5').\
			place('d','6',CheckersGame::Square::BLACK,false).toggle_turn,mygame)
	end
	def test_erroneous_moves_ArgumentError_2
		#Test testing that From coordinates contain player's piece
		#Contains other player's color
		mygame=CheckersGame.new
		assert_raise(ArgumentError){mygame.move('f4','e5')}
		assert_equal(CheckersGame.new,mygame)
	end
	def test_erroneous_moves_ArgumentError_3
		#Test testing that From coordinates contain player's piece
		#Square is blank
		mygame=CheckersGame.new
		assert_raise(ArgumentError){mygame.move('d6','e7')}
		assert_equal(CheckersGame.new,mygame)
	end
	def test_erroneous_moves_ArgumentError_4
		#Test testing that To coordinates are unoccupied
		#Unoccupied case:
		mygame=CheckersGame.new
		assert_nothing_raised(ArgumentError){mygame.move('c1','d2')}
		assert_nothing_raised(ArgumentError){mygame.move('f4','e3')}
	end
	def test_erroneous_moves_ArgumentError_5
		mygame=CheckersGame.new.move('c1','d2').move('f4','e3')
		#Trying to move to a space occupied by opponent
		assert_raise(ArgumentError){mygame.move('d2','e3')}
	end
	def test_erroneous_moves_ArgumentError_6
		mygame=CheckersGame.new.move('c1','d2').move('f4','e3')
		#Trying to move to a space occupied by self
		assert_raise(ArgumentError){mygame.move('c3','d2')}
	end
	def test_erroneous_moves_illegal_move
		#Test testing move legality
		#We've already had plenty of positive cases go through
		#Here are some negative cases
		mygame=CheckersGame.new
		assert_raise(ArgumentError){mygame.move('c1','e3')}
		assert_raise(ArgumentError){mygame.move('c3','d6')}
		assert_raise(ArgumentError){mygame.move('c5','e5')}
		assert_raise(ArgumentError){mygame.move('c7','d2')}
		
	end
	#Test detection of a single capture move
	def test_single_capture
		mygame=CheckersGame.new
		mygame.move('c3','d4').move('f6','e5')
		#  +---+---+---+---+---+---+---+---+
		#	h |   | r |   | r |   | r |   | r | 
		#	  +---+---+---+---+---+---+---+---+
		#	g | r |   | r |   | r |   | r |   | 
		#	  +---+---+---+---+---+---+---+---+
		#	f |   | r |   | r |   | . |   | r | 
		#	  +---+---+---+---+---+---+---+---+
		#	e | . |   | . |   | r |   | . |   | 
		#	  +---+---+---+---+---+---+---+---+
		#	d |   | . |   | b |   | . |   | . | 
		#	  +---+---+---+---+---+---+---+---+
		#	c | b |   | . |   | b |   | b |   | 
		#	  +---+---+---+---+---+---+---+---+
		#	b |   | b |   | b |   | b |   | b | 
		#	  +---+---+---+---+---+---+---+---+
		#	a | b |   | b |   | b |   | b |   | 
		#	  +---+---+---+---+---+---+---+---+
		#		1   2   3   4   5   6   7   8 
		mygame.move('d4','f6')
		#assert_equal(CheckersGame.new.remove('c','3').place('f','6',CheckersGame::Square::BLACK,false).toggle_turn,mygame)
		
	end
end