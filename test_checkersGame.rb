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
	#test initialization and test to_s
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
	#test [] operator.  
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
		b=CheckersGame::BlackSquare::BLACK
		r=CheckersGame::BlackSquare::RED
		x=CheckersGame::BlackSquare::BLANK
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
		mygame=CheckersGame.new
		mygame.move('c3','d4')
		assert_not_equal(CheckersGame.new,mygame)
	end
	def test_remove_and_place
		assert_equal(CheckersGame::BlackSquare::BLANK,CheckersGame.new.remove('c','3')['c','3'].color)
		assert_equal(CheckersGame::BlackSquare::RED,\
			CheckersGame.new.place('c','3',CheckersGame::BlackSquare::RED,false)['c','3'].color)
		#test error case
		assert_raise(IndexError){CheckersGame.new.remove('c','*')}
		assert_raise(IndexError){CheckersGame.new.remove('*','3')}
	end
	def test_first_legal_moves
		black_columns=%w[1 3 5 7]
		red_columns=%w[2 4 6 8]
		#Test some initial moves for Black
		for i in 0...4
			mygame=CheckersGame.new
			assert_equal(\
				CheckersGame.new.remove('c',black_columns[i]).\
				place('d',String(Integer(black_columns[i])+1),\
				CheckersGame::BlackSquare::BLACK,false).toggle_turn,\
				mygame.move('c'+black_columns[i],'d'+String(Integer(black_columns[i])+1)))
		end
		#Test some counter moves for Red for one of the black openings
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
				CheckersGame::BlackSquare::RED,false).toggle_turn,\
				mygame.move('f'+red_columns[i],'e'+String(Integer(red_columns[i])-1)))
		end
	end
	def test_erroneous_moves
		#test coordinate legality testing
		#neither illegal
		assert_nothing_raised(IndexError,ArgumentError){CheckersGame.new.move('c1','d2')}
		#one illegal
		mygame=CheckersGame.new
		assert_raise(IndexError){mygame.move('*1','d2')}
		assert_equal(CheckersGame.new,mygame)
		mygame=CheckersGame.new
		assert_raise(IndexError){mygame.move('c*','d2')}
		assert_equal(CheckersGame.new,mygame)
		mygame=CheckersGame.new
		assert_raise(IndexError){mygame.move('c1','*2')}
		assert_equal(CheckersGame.new(),mygame)
		mygame=CheckersGame.new
		assert_raise(IndexError){mygame.move('c1','d*')}
		assert_equal(CheckersGame.new,mygame)
		#both illegal
		mygame=CheckersGame.new
		assert_raise(IndexError){mygame.move('c*','d*')}
		assert_equal(CheckersGame.new,mygame)
		
		#test testing for playing only on black squares
		#From coordinates:
		for i in 1..8
			mygame=CheckersGame.new
			if((i-1)%2==1)
				assert_raise(IndexError){mygame.move('c'+String(i),'d4')}
				assert_equal(CheckersGame.new,mygame)
			end
		end
		#To coordinates:
		for i in 1..8
			mygame=CheckersGame.new
			if(i%2==1)
				assert_raise(IndexError){mygame.move('c1','d'+String(i))}
				assert_equal(CheckersGame.new,mygame)
			end
		end
		#Both coordinates:
		for i in 1..7
			mygame=CheckersGame.new
			if((i-1)%2==1)
				assert_raise(IndexError){mygame.move('c'+String(i),'d'+String(i+1))}
				assert_equal(CheckersGame::BlackSquare::BLACK,mygame.whose_turn)
			end
		end
		
		#Test testing that From coordinates contain player's piece
		#Contains correct color
		mygame=CheckersGame.new
		assert_nothing_raised(ArgumentError){mygame.move('c5','d6')}
		assert_equal(CheckersGame.new.remove('c','5').\
			place('d','6',CheckersGame::BlackSquare::BLACK,false).toggle_turn,mygame)
		#Contains other player's color
		mygame=CheckersGame.new
		assert_raise(ArgumentError){mygame.move('f4','e5')}
		assert_equal(CheckersGame.new,mygame)
		#Square is blank
		mygame=CheckersGame.new
		assert_raise(ArgumentError){mygame.move('d6','e7')}
		assert_equal(CheckersGame.new,mygame)
		
		#Test testing that To coordinates are unoccupied
		#Unoccupied case:
		mygame=CheckersGame.new
		assert_nothing_raised(ArgumentError){mygame.move('c1','d2')}
		assert_nothing_raised{mygame.move('f4','e3')}
		#Trying to move to a space occupied by opponent
		assert_raise(ArgumentError){mygame.move('d2','e3')}
		#Trying to move to a space occupied by self
		assert_raise(ArgumentError){mygame.move('c3','d2')}
		
		#Test testing move legality
		#We've already had plenty of positive cases go through
		#Here are some negative cases
		mygame=CheckersGame.new
		assert_raise(ArgumentError){mygame.move('c1','e3')}
		assert_raise(ArgumentError){mygame.move('c3','d6')}
		assert_raise(ArgumentError){mygame.move('c5','e5')}
		assert_raise(ArgumentError){mygame.move('c7','d2')}
		
	end
end