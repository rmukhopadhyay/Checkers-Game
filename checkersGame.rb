#!/usr/bin/env ruby

#Implements a game of checkers.  Attribute whose_turn is used to determine whose turn 
#it currently is in the game.  Method CheckersGame#move requires the coordinates 
#of the current location 
#of the piece you want to move and the coordinates (as a string) 
#of the location you want to move it to.  
#The labels of the rows and columns are the keys of the dictionaries 
#ROW_LOOKUP and COLUMN_LOOKUP.  
#They are presently set so that rows are labelled from a to h going away 
#from the black player and from 1 to 8 from left to right.  On 
#initialization, the board looks like:
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
#	    1   2   3   4   5   6   7   8 
#and it is black's turn.  This representation of the checkers board can be 
#obtained by calling CheckersGame#to_s.  

class CheckersGame
	#Number of squares on each side of the board
	BOARD_SIZE=8
	#Number of rows initially occupied with pieces
	NUM_INIT_ROWS=3
	#Symbols used to index the rows of the board
	ROW_LOOKUP={'a'=>0,'b'=>1,'c'=>2,'d'=>3,'e'=>4,'f'=>5,'g'=>6,'h'=>7}
	#Symbols used to index the columns of the board
	COLUMN_LOOKUP={'1'=>0,'2'=>1,'3'=>2,'4'=>3,'5'=>4,'6'=>5,'7'=>6,'8'=>7}
	#Create a new checkers game.  Black goes first.
	def initialize()
		@gameboard=Array.new(BOARD_SIZE,nil);
		for i in 0...BOARD_SIZE
			@gameboard[i]=Array.new(BOARD_SIZE,nil);
			for j in 0...BOARD_SIZE
				if((i+j)%2==0)	#Black (playable) square
					if(i<NUM_INIT_ROWS)	
						#place a black checker
						@gameboard[i][j]=Square.new Square::BLACK
					elsif(i>=BOARD_SIZE-NUM_INIT_ROWS)	
						#place a red checker
						@gameboard[i][j]=Square.new Square::RED
					else
						#Square is legal but unoccupied
						@gameboard[i][j]=Square.new
					end
				end
			end
		end		
		#Without loss of generality, black goes first
		@whose_turn=Square::BLACK
	end
	#Returns Square::RED or Square::BLACK depending on 
	#whose turn it is.
	attr_reader :whose_turn
	
	#For printing: column delimiter
	@@COLUMN_DELIMITER=' | '
	#For printing: row delimiter
	@@ROW_DELIMITER='  +'+'---+'*BOARD_SIZE+"\n"
	#Print out ascii version of game state with rows and columns labelled.  
	#Output looks something like:
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
		#	    1   2   3   4   5   6   7   8 
	def to_s
		board=@@ROW_DELIMITER
		for i in (BOARD_SIZE-1).downto(0) #origin is at bottom left of board
			board+=ROW_LOOKUP.invert[i]+@@COLUMN_DELIMITER
			for j in 0...BOARD_SIZE
				if @gameboard[i][j]
					board+=@gameboard[i][j].to_c+@@COLUMN_DELIMITER
				else
					board+=' '+@@COLUMN_DELIMITER
				end
			end
			board+="\n"+@@ROW_DELIMITER
		end
		board+='  ';
		for j in 0...BOARD_SIZE
			board+='  '+COLUMN_LOOKUP.invert[j]+' '
		end
		board+="\n"
		return board
	end
	#Returns a copy of the Square object that is at the specified 
	#row and column of the board.  _row_ and _column_ are single letter strings from 
	#the sets ROW_LOOKUP.keys and COLUMN_LOOKUP.keys 
	#(presently, a-h 1-8 respectively).  Returns nil for unplayable (red) squares.
	#Raises IndexError if index is invalid.  
	def [](row,column)
		row_number=ROW_LOOKUP[row]
		column_number=COLUMN_LOOKUP[column]
		if(row_number && column_number)
			if(square=@gameboard[row_number][column_number])
				return Square.new(@gameboard[row_number][column_number].color,@gameboard[row_number][column_number].kinged)
			else
				return nil
			end
		else
			raise IndexError, "#{row+column} is not a valid (row, column) pair.  "
		end
	end
	#Tests if two checkers games are in the same state
	def ==(other)
		ROW_LOOKUP.keys.each do |row|
			COLUMN_LOOKUP.keys.each do |column|
				if(@gameboard[ROW_LOOKUP[row]][COLUMN_LOOKUP[column]]!=other[row,column])
					return false
				end
			end
		end
		return @whose_turn==other.whose_turn
	end
	#This removes a piece from the Checker's board.  It is not recomended to do this for any 
	#reason other than testing.  _row_ and _col_ are valid keys for ROW_LOOKUP 
	#and COLUMN_LOOKUP respectively.  Raises IndexError if the supplied indices 
	#are invalid or correspond to a red (unplayable) square on the board.  
	def remove(row,col)
		place(row,col,Square::BLANK,false)
	end
	
	#This places a piece onto the Checker's board.  It is not recomended to do this for any 
	#reason other than testing.  _row_ and _col_ are valid keys for ROW_LOOKUP 
	#and COLUMN_LOOKUP respectively.  _color_ is one of 
	#Square::RED, Square::BLACK or 
	#Square::BLANK.  _kinged_ is true or false depending on if the 
	#piece is kinged or not.  
	#Raises IndexError if the supplied indices 
	#are invalid or correspond to a red (unplayable) square on the board.  
	def place(row,col,color,kinged)
		row_number=ROW_LOOKUP[row]
		column_number=COLUMN_LOOKUP[col]
		if (row_number && column_number && ((row_number+column_number)%2==0))
			@gameboard[row_number][column_number]=Square.new(color,kinged)
		else
			raise IndexError
		end
		return self
	end
	#This changes whose turn it is.  Should not be used except during debugging or testing
	def toggle_turn
		@whose_turn=other_player
		return self
	end
	def other_player
		@whose_turn==Square::BLACK ? Square::RED : Square::BLACK
	end

	#from and to are strings where the first letter is a row and the 
	#second is a column.  
	#from specifies which piece to move and to specifies where to move it
	#if the move is legal, the game state is changed accordingly and 
	#the method returns 0.  
	#For example:
	#	my_game=CheckersGame.new
	#	my_game.move('c3','d4')
	#Changes the game state from 
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
	#	    1   2   3   4   5   6   7   8 
	#To
	#	  +---+---+---+---+---+---+---+---+
	#	h |   | r |   | r |   | r |   | r | 
	#	  +---+---+---+---+---+---+---+---+
	#	g | r |   | r |   | r |   | r |   | 
	#	  +---+---+---+---+---+---+---+---+
	#	f |   | r |   | r |   | r |   | r | 
	#	  +---+---+---+---+---+---+---+---+
	#	e | . |   | . |   | . |   | . |   | 
	#	  +---+---+---+---+---+---+---+---+
	#	d |   | . |   | b |   | . |   | . | 
	#	  +---+---+---+---+---+---+---+---+
	#	c | b |   | . |   | b |   | b |   | 
	#	  +---+---+---+---+---+---+---+---+
	#	b |   | b |   | b |   | b |   | b | 
	#	  +---+---+---+---+---+---+---+---+
	#	a | b |   | b |   | b |   | b |   | 
	#	  +---+---+---+---+---+---+---+---+
	#	    1   2   3   4   5   6   7   8 
	#	Errors: 
	#	IndexError:		From coordinates are out of bounds
	#	IndexError:		From coordinates are not a black square
	#	IndexError:		To coordinates are out of bounds
	#	IndexError:		To coordinates are not a black square
	#	ArgumentError:	From coordinates don't contain current player's piece
	#	ArgumentError:	To coordinates are already occupied
	#	ArgumentError:	To coordinates cannot be moved to using a legal, implemented move
	def move(from,to)
		#Initialize error state to 0
		error=0
		
		#Check for coordinate legality
		from_row=ROW_LOOKUP[from[0..0]]
		from_column=COLUMN_LOOKUP[from[1..1]]
		to_row=ROW_LOOKUP[to[0..0]]
		to_column=COLUMN_LOOKUP[to[1..1]]
		
		raise(IndexError, 'Invalid indices for from coordinates') unless from_row && from_column
		raise(IndexError, 'Invalid indices for to coordinates') unless to_row && to_column
		
		#Check that coordinates are a playable (black) square
		raise(IndexError, 'from coordinates are unplayable') unless (from_row+from_column)%2==0
		raise(IndexError, 'to coordinates are unplayable') unless (to_row+to_column)%2==0
		
		
		#Check that From coordinates contain the current player's piece
		raise(ArgumentError, 'from coordinates do not contain current player''s piece') \
			unless (@gameboard[from_row][from_column].color==whose_turn)

		#Check that To coordinates are unoccupied
		raise(ArgumentError,'To coordinates are occupied') \
			unless (@gameboard[to_row][to_column].color==Square::BLANK)
		
		if (! ((@whose_turn==Square::BLACK ? from_row+1 : from_row-1) ==
				to_row && (to_column-from_column).abs==1 || 
				( ((to_row - from_row).abs == 2) && ((to_column - from_column).abs == 2) && \
				@gameboard[from_row+((to_row-from_row)<=>0)][from_column+((to_column-from_column)<=>0)].color==other_player)))
			raise ArgumentError, 'Relative positions of from and to squares are not legal' # TODO add some info
		end
		
		@gameboard[to_row][to_column]=@gameboard[from_row][from_column]
		@gameboard[from_row][from_column]=Square.new
		if((to_column-from_column).abs==2)
			@gameboard[to_row+((to_row-from_row)<=>0)][to_column+((to_column-from_column)<=>0)]=Square.new
		end
		toggle_turn
		return self
	end
	#Stores the state of the black (playable) checkers squares.  
	#Attribute _color_ is either Square::BLACK_, 
	#Square::RED or Square::BLANK.  
	#Attribute _kinged_ is either true or false depending on whether or 
	#not the piece in the current square is kinged.  
	class Square
		BLACK='b'
		RED='r'
		BLANK='.'
		#Accepts a color and a boolean that indicates whether or not the 
		#current piece is a king.
		#Raises ArgumentError if given a color other than 
		#Square::BLACK, Square::RED or 
		#Square::BLANK.  
		def initialize(color=Square::BLANK,kinged=false)
			if(color!=BLACK&&color!=RED&&color!=BLANK)
				raise ArgumentError, "#{color} is not a valid color"
			end
			@color=color
			@kinged=kinged
			if(@color==BLANK)
				@kinged=false
			end
		end
		@@TO_S_DICTIONARY={BLACK=>'Black',RED=>'Red',BLANK=>'Blank Square'}
		@@SINGLE_LETTER={BLACK=>'b',RED=>'r',BLANK=>'.'}
		#Generates string representations such as "Black" or "Red King"
		def to_s
			return @@TO_S_DICTIONARY[@color]+(kinged ? ' King':'')
		end
		#Generates a single letter representation of the square.  
		def to_c
			return (kinged ? @@SINGLE_LETTER[@color].upcase : @@SINGLE_LETTER[@color])
		end
		#Color of the piece in the square
		attr_reader :color
		#True if the piece is non-blank and a King
		attr_reader :kinged
		#Tests for equality of Square state
		def ==(other)
			return (@color==other.color)&&(@kinged==other.kinged)
		end
	end
end


if __FILE__==$0
	puts "Hello World!"
	cgame=CheckersGame.new()
	puts cgame
	puts cgame.move('c1','d2')
	puts cgame
	puts cgame.move('f4','e3')
	puts cgame
end