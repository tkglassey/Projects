package BlackJackFolder;
class Card
{
    public Card next;
    private String suit;
    private int rank;

    Card(String suit, int rank)
    {
        this.suit = suit;
        this.rank = rank;
    } // end Card()

    Card(Card card)
    {
        suit = card.suit;
        rank = card.rank;
    } // end Card()

    private String getRankName()
    {
        if (rank == 1)
            return "A";
        else if (rank == 11)
            return "J";
        else if (rank == 12)
            return "Q";
        else if (rank == 13)
            return "K";
        else
            return String.valueOf(rank);
    } // end getRankName()

    public int getValue()
    {
        if (rank == 1)
            return 11;
        else if (rank == 11 || rank == 12 || rank == 13)
            return 10;

        return rank;
    } // end getValue()

    public String getSuit()
    {
        return suit;
    } // end getSuit()

    public int getRank()
    {
        return rank;
    } // end getRank()

    public void showCard()
    {
        System.out.print(" " + getRankName() + "_" + suit);
    } // end showCard()

    @Override
    public String toString()
    {
        return getRankName() + "_" + suit;
    } // end toString()
} // end Card