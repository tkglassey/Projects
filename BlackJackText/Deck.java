package BlackJackFolder;
class Deck
{
    private int maxSize;
    private Card[] stackArray;
    private int top;

    public Deck(int s)
    {
        maxSize = s;
        stackArray = new Card[maxSize];
        top = -1;
    } // end Deck()

    private void push(Card card)
    {
        stackArray[++top] = new Card(card);
    } // end push()

    public Card pop()
    {
        return stackArray[top--];
    } // end pop()

    public boolean isEmpty()
    {
        return top == -1;
    } // end isEmpty()

    public void shuffleDeck()
    {
        Card swap;

        for (int i = 0; i < stackArray.length; i++) 
        {
            int r = i + (int) (Math.random() * (stackArray.length - i));
            swap = stackArray[i];
            stackArray[i] = stackArray[r];
            stackArray[r] = swap;
        } // end for()
    } // end shuffleDeck()

    public void createDeck()
    {
        String[] suit = {"\u2663", "\u2666", "\u2665", "\u2660"};
        int[] rank = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13};

        for (int i = 0; i < rank.length; i ++)
        {
            for (int j = 0; j < suit.length; j++)
            {
                push(new Card(suit[j], rank[i]));
            } // end for()
        } // end for()
    } // end createDeck()
} // end Deck
