package net.houen.cactuskev ;
import net.houen.cactuskev.PokerVars;

/**
 * A haxe port of the as3 poker hand evaluator writen by Søren Houen, based on cactuskev's poker evaluator
 */
class PokerLib
{

	public function new() 
	{
		
	}
	
	private static var STRAIGHTS:Array<Int> = []; //new short[7937];

        /// <summary>
        /// Replaces the Macro from the c version - returns the rank of a card
        /// </summary>
        /// <param name="card">The card to get the rank from</param>
        /// <returns>integer rank of the card</returns>
        public static function RANK(card:Int):Int
        {
            return ((card >>> 8) & 0xF);
        }
        
        public static function SUIT(card:Int):String
        {
                if (( card & 0x8000 ) == 0x8000)
                    return 'c';
                else if (( card & 0x4000 ) == 0x4000)
                    return 'd';
                else if (( card & 0x2000 ) == 0x2000)
                    return 'h';
                else
                    return 's';
        }

        /// <summary>
        ///  perform a binary search on a pre-sorted array
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static function findit(key:Int):Int
        {
            var low:Int = 0, high:Int = 4887, mid:Int;

            while (low <= high)
            {
                mid = (high + low) >> 1;      // divide by two
                if (key < CactusArrays.products[mid])
                    high = mid - 1;
                else if (key > CactusArrays.products[mid])
                    low = mid + 1;
                else
                    return (mid);
            }
            
            throw "no match found; key = " + key;
        }

        /// <summary>
        ///   This routine initializes the deck.  A deck of cards is
        ///   simply an integer array of length 52 (no jokers).  This
        ///   array is populated with each card, using the following
        ///   scheme:
        ///
        ///   An integer is made up of four bytes.  The high-order
        ///   bytes are used to hold the rank bit pattern, whereas
        ///   the low-order bytes hold the suit/rank/prime value
        ///   of the card.
        ///
        ///   +--------+--------+--------+--------+
        ///   |xxxbbbbb|bbbbbbbb|cdhsrrrr|xxpppppp|
        ///   +--------+--------+--------+--------+
        ///
        ///   p = prime number of rank (deuce=2,trey=3,four=5,five=7,...,ace=41)
        ///   r = rank of card (deuce=0,trey=1,four=2,five=3,...,ace=12)
        ///   cdhs = suit of card
        ///   b = bit turned on depending on rank of card
        /// </summary>
        /// <param name="deck"></param>
        public static function init_deck(deck:Array<Int>):Void //Int[] deck
        {
            var i:Int, j:Int, n:Int = 0, suit:Int = 0x8000;

            for (i in 0...4)
			{
                for (j in 0...13)
				{
                    deck[n] = CactusArrays.primes[j] | (j << 8) | suit | (1 << (16 + j));
					n++;
				}					
				suit >>>= 1;
			}
        }


        /// <summary>
        ///  This routine will search a deck for a specific card
        ///  (specified by rank/suit), and return the INDEX giving
        ///  the position of the found card.  If it is not found,
        ///  then it returns -1
        /// </summary>
        /// <param name="rank">the rank of the card to find</param>
        /// <param name="suit">the suit of the cards to find</param>
        /// <param name="deck">the deck of cards to search</param>
        /// <returns>the index of card or -1 if not found</returns>
        public static function find_card(rank:Int, suit:Int, deck:Array<Int> /* Int[] */):Int
        {
            var i:Int, c:Int;

            for (i in 0...52)
            {
                c = deck[i];
                if ((c & suit)!=0 && (RANK(c) == rank))
                    return (i);
            }
            return (-1);
        }

        /// <summary>
        //  This routine takes a deck and randomly mixes up
        //  the order of the cards.
        /// </summary>
        /// <param name="deck">The deck to shuffle</param>
        public static function shuffle_deck(deck:Array<Int>):Void
        {
            var r:Int;

            var i:Int, n:Int;
            var temp:Array<Int> = [];
            
            //Put zeroes in all places in temp
            for(j in 0...52) {
            	temp[j] = 0;
            }

            for (i in 0...52)
                temp[i] = deck[i];

            for (i in 0...52)
            {
                do
                {
                    n = Math.floor(Math.random() * 52); //(51.9999999 * drand48());

                } while (temp[n] == 0);

                deck[i] = temp[n];
                temp[n] = 0;
            }
        }

        //private static var rank:Array = ['2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A'];
        public static function print_hand(hand:Array<Int>, n:Int):String
        {
            var returnValue:String = "";

            var i:Int, r:Int;
            var suit:String;
            for (i in 0...n)
            {
                r = RANK(hand[i]);
                suit = SUIT(hand[i]);
                /*if (( hand[i] & 0x8000 ) == 0x8000)
                    suit = 'c';
                else if (( hand[i] & 0x4000 ) ==0x4000)
                    suit = 'd';
                else if (( hand[i] & 0x2000 ) == 0x200)
                    suit = 'h';
                else
                    suit = 's';*/
                
                returnValue += PokerVars.cardRank[r] + suit + " ";
            }

            return returnValue;
        }


        public static function hand_rank( val:Int /* ushort */ ):Int
        {
            if (val > 6185) return(PokerVars.HIGH_CARD);        // 1277 high card
            if (val > 3325) return(PokerVars.ONE_PAIR);         // 2860 one pair
            if (val > 2467) return(PokerVars.TWO_PAIR);         //  858 two pair
            if (val > 1609) return(PokerVars.THREE_OF_A_KIND);  //  858 three-kind
            if (val > 1599) return(PokerVars.STRAIGHT);         //   10 straights
            if (val > 322)  return(PokerVars.FLUSH);            // 1277 flushes
            if (val > 166)  return(PokerVars.FULL_HOUSE);       //  156 full house
            if (val > 10)   return(PokerVars.FOUR_OF_A_KIND);   //  156 four-kind
            if (val <= 0)  	throw "BAD VAL";							// A Hand can not be less than 0, so we have a serious error
            return(PokerVars.STRAIGHT_FLUSH);                   //   10 straight-flushes
        }

		
		public static function eval_5cards(c1:Int, c2:Int, c3:Int, c4:Int, c5:Int):Int
		{
			var q:Int;
			var s:Int;
			
			q = (c1 | c2 | c3 | c4 | c5) >> 16;
			
			// check for Flushes and StraightFlushes
            if ((c1 & c2 & c3 & c4 & c5 & 0xF000)!=0)
                return (CactusArrays.flushes[q]);

            // check for Straights and HighCard hands
            s = CactusArrays.unique5[q];
            if (s!=0) return (s);

			/* let's do it the hard way
            */
            q = (c1 & 0xFF) * (c2 & 0xFF) * (c3 & 0xFF) * (c4 & 0xFF) * (c5 & 0xFF);
            q = findit(q);

            return (CactusArrays.values[q]);
		}
}