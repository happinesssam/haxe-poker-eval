package net.houen.cactuskev;

/**
 * A haxe port of the as3 poker hand evaluator writen by Søren Houen, based on cactuskev's poker evaluator
 */
class PokerVars
{
	public static inline var   STRAIGHT_FLUSH:Int  = 1;
	public static inline var   FOUR_OF_A_KIND:Int = 2;
	public static inline var   FULL_HOUSE:Int = 3;
	public static inline var   FLUSH:Int = 4;
	public static inline var   STRAIGHT:Int = 5;
	public static inline var   THREE_OF_A_KIND:Int = 6;
	public static inline var   TWO_PAIR:Int = 7;
	public static inline var   ONE_PAIR:Int = 8;
	public static inline var   HIGH_CARD:Int = 9;

	public static inline var   CLUB:Int = 0x8000;
	public static inline var   DIAMOND:Int = 0x4000;
	public static inline var   HEART:Int = 0x2000;
	public static inline var   SPADE:Int = 0x1000;

	public static inline var   Deuce:Int = 0;
	public static inline var   Trey:Int = 1;
	public static inline var   Four:Int = 2;
	public static inline var   Five:Int = 3;
	public static inline var   Six:Int = 4;
	public static inline var   Seven:Int = 5;
	public static inline var   Eight:Int = 6;
	public static inline var   Nine:Int = 7;
	public static inline var   Ten:Int = 8;
	public static inline var   Jack:Int = 9;
	public static inline var   Queen:Int = 10;
	public static inline var   King:Int = 11;
	public static inline var   Ace:Int = 12;
	
	public static var handRank:Array<String> = ['ERROR HAND!', 'Straight Flush', 'Four of a Kind', 'Full House', 'Flush', 'Straight', 'Three of a Kind', 'Two Pair', 'One Pair', 'High Card'];
	public static var cardRank:Array<String> = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'];
	public static var cardRankNum:Array<Int> = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14];
	
}