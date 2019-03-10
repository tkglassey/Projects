package BlackJackFolder;
class Hand
{
    private Card first;
    private int cardTotal;
    private String name;
    private int handSize;

    public Hand(String name)
    {
        first = null;
        this.name = name;
        cardTotal = 0;
        handSize = 0;
    } // end Hand()

    public void insert(Card card)
    {
        Card newLink = new Card(card);
        newLink.next = first;

        if (card.getRank() == 1 && cardTotal + card.getValue() > 21)
            cardTotal = cardTotal + (card.getValue() - 10);
        else
            cardTotal = cardTotal + card.getValue();

        handSize = handSize + 1;

        first = newLink;
    } // end insert()

    public Card deleteFirst()
    {
        Card temp = first;
        first = first.next;
        cardTotal = cardTotal - temp.getValue();
        handSize = handSize - 1;
        return temp;
    } // end deleteFirst()

    public void displayHand()
    {
        Card current = first;
        while(current != null)
        {
            current.showCard();
            current = current.next;
        } // end while()
    } // end displayHand()

    public boolean isEmpty()
    {
        return first == null;
    } // end isEmpty()

    public boolean bothEqual()
    {
        Card temp = first;
        return temp != null && (temp.getValue() == temp.next.getValue());
    } // end bothEqual()

    public void peek()
    {
        first.showCard();
    } // end peek()

    public int peekValue()
    {
        return first.getValue();
    } // end peekValue()

    public int getHandSize()
    {
        return handSize;
    } // end getHandSize()

    public String getName()
    {
        return name;
    } // end getName()

    public int getHandTotal()
    {
        return cardTotal;
    } // end getHandTotal()
} // end Hand
