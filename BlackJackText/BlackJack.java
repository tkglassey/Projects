package BlackJackFolder;
import java.io.*;
import java.util.*;
public class BlackJack
{
    private static int BLACKJACK = 21;
    private static int DECKSIZE = 52;
    private static boolean isPlayerDone;
    private static ArrayList<Hand> players;
    private static int playerCount;
    private static Hand dealersHand;
    private static int currentPlayer;
    private static int splitHand;
    public static void main(String[] args) throws IOException 
    {
        Deck deck = null;
        
        
        

        System.out.println("--------------------------------------------------------"); 
        System.out.println("-               BLACK               JACK               -");
        System.out.println("--------------------------------------------------------\n"); 
        boolean runGame = true;
        System.out.println("How many players will there be?");
        Scanner input = new Scanner(System.in);
        playerCount = input.nextInt();
        
        while(runGame)
        {
                    dealersHand = new Hand("Dealer");
                    //playersHand = new Hand("Player")
                    players = new ArrayList<Hand>();
                    currentPlayer = 0;
                    splitHand = 0;
                    isPlayerDone = false;
                    for(int i = 0; i<playerCount;i++)
                    {
                        Hand temp = new Hand("Player "+(i+1));
                        players.add(temp);
                    }
                    deck = initialDraw(deck);
                    
                    while(!isPlayerDone)
                    {
                        Hand player = players.get(currentPlayer);
                        showHands();
                        if (player.getHandTotal() == BLACKJACK)
                        {
                         System.out.print("Player has BLACKJACK!\n\n");
                         if((currentPlayer+1)<playerCount)
                         {currentPlayer++;}
                         else
                         {
                            isPlayerDone = true;
                            deck = stand(deck);
                         }
                         /*
                         isPlayerDone = true;
                         System.out.print("Dealer uncovers card...\n\n");
                         showHands(playersHand, splitHand, dealersHand);
                         System.out.print("Dealer's move...\n\n");
                         deck = dealerDraw(deck, playersHand, splitHand, dealersHand);
                         showHands(playersHand, splitHand, dealersHand);
                         compareHands(playersHand, splitHand, dealersHand);
                         */
                        } // end if()
                        else if(player.getHandTotal() > BLACKJACK)
                        {
                            System.out.print(player.getName()+ " Busted!\n\n");
                            if((currentPlayer+1)<playerCount)
                                {currentPlayer++;}
                            else
                            {
                                isPlayerDone = true;
                                deck = stand(deck);
                            }
                            
                        }
                         switch(options())
                         {
                        

                    

                            case "hit":
                            if(!isPlayerDone)
                             deck = hit(deck, players.get(currentPlayer));
                            else
                            System.out.print("You must deal cards first!\n\n");
                            break; // end case "hit"

                          case "stand":
                            if(!isPlayerDone && (currentPlayer+1)<playerCount)
                            {
                                currentPlayer++;
                        
                            } // end if()
                            else if(!isPlayerDone && (currentPlayer+1)>=playerCount)
                            {
                                isPlayerDone=true;
                                deck = stand(deck);
                            }
                            else
                                System.out.print("You must deal cards first!\n\n");
                            break; // end case "stand"

                            case "split":
                            if(!isPlayerDone)
                             deck = split(deck, players.get(currentPlayer));
                            else
                            System.out.print("You must deal cards first!\n\n");
                            break; // end case "split"

                          case "exit":
                            runGame = false;
                            isPlayerDone = false;
                            System.out.print("Game ended.\n\n");
                            return; // end case "exit"

                          default:
                          System.out.print("Invalid entry\n\n");
                        }
                        
                    }
                    
            } // end switch()
        }// end main()
     

    private static Deck split(Deck deck,Hand player)
    {
        if(player == null)
            System.out.print("You must deal cards first!\n\n");
        else if(player.getHandSize() == 2 && player.bothEqual())
        {
            Hand split = new Hand("Player "+currentPlayer+" split");
            split.insert(player.deleteFirst());
            deck = drawFromDeck(deck, player);
            deck = drawFromDeck(deck, split);
            players.add(split);
            showHands(player);
            showHands(split);
            splitHand++;
            playerCount++;
        } // end else if()
        else if(!player.bothEqual())
            System.out.print("Both card values must be the same!\n\n");
        else
            System.out.print("You must have no more than 2 cards to split!\n\n");

        return deck;
    } // end split()

    private static Deck stand(Deck deck)
    {
        if(dealersHand == null)
            System.out.print("You must deal cards first!\n\n");
        else
        {   
            isPlayerDone = true;
            System.out.print("Dealer uncovers card...\n\n");
            showHands();
            System.out.print("Dealer's move...\n\n");
            deck = dealerDraw(deck);
            showHands();
            compareHands();
        } // end else

        return deck;
    } // end stay()

    private static Deck hit(Deck deck, Hand player)
    {
        if(player == null)
            System.out.print("You must deal cards first!\n\n");
        else
        {       
            deck = drawFromDeck(deck, player);
            System.out.print("\n");

            
            
            

            if (player.getHandTotal() == BLACKJACK)
            {
                //System.out.print(player.getName() " has BLACKJACK!\n\n");
                /*isPlayerDone = true;
                System.out.print("Dealer uncovers card...\n\n");
                showHands(player, split, dealer);
                System.out.print("Dealer's move...\n\n");
                deck = dealerDraw(deck, player, split, dealer);
                showHands(player, split, dealer);
                compareHands(player, split, dealer);*/
            } // end if()
            
        } // end else

        return deck;
    } // end hit()

    private static Deck dealerDraw(Deck deck)
    {
        
        
            // Dealer takes a precaution and only draws 
            // if hand total is less than or equal to 16.
            while(dealersHand.getHandTotal() <= 16)
                deck = drawFromDeck(deck, dealersHand);

        
        

        return deck;
    } // dealerDraw()

    private static Deck drawFromDeck(Deck deck, Hand hand)
    {
        deck = checkDeck(deck);

        Card temp = new Card(deck.pop());

        if (hand.getName().equals("Dealer") && !isPlayerDone)
        {
            if(hand.getHandSize() < 1)
                System.out.print("Drawing Dealer's card... X_X");
            else
                System.out.print("Drawing Dealer's card... " + temp.toString());
        } // end if()
        else
        {
            if(hand.getName().equals("Dealer"))
                System.out.print("Drawing Dealer's card... " + temp.toString() + "\n");
            else
                System.out.print("Drawing "+hand.getName()+" card... " + temp.toString());
        } // end else

        System.out.print("\n");

        hand.insert(temp);

        return deck;
    } // end drawFromDeck()

    private static void compareHands()
    {
        if (isPlayerDone)
        {
          for(int i = 0;i<playerCount;i++)
          {
              Hand player = players.get(i);
            if(player.getHandTotal() > BLACKJACK)
            {
                System.out.print(player.getName()+" Busted!\n");
                System.out.print("Dealer beats " + player.getName()+"!\n\n");
            } // end if()
            else if(dealersHand.getHandTotal() > BLACKJACK)
            {
                System.out.print("Dealer Busted!\n");
                if(player.getHandTotal() <= BLACKJACK)
                    System.out.print(player.getName() +" Wins!\n\n");
            } // end else if()
            else
            {
                if(player.getHandTotal()==BLACKJACK)
                {
                    System.out.print(player.getName() +" has BLACKJACK!\n\n");
                }
                else if (player.getHandTotal()>dealersHand.getHandTotal())
                {
                    System.out.print(player.getName() +" Wins!\n\n");
                }
                else if (player.getHandTotal()==dealersHand.getHandTotal())
                {
                    System.out.print(player.getName()+" Pushed!\n\n");
                }
                else 
                {
                    System.out.print("Dealer beats "+player.getName()+"!\n\n");
                }
            } // end else
          }
        } // end if()
        for(int i = 0; i<splitHand;i++)
        {
            players.remove(playerCount-1);
            playerCount= playerCount-1;
        }
    } // end compareHands()

    private static Deck checkDeck(Deck deck)
    {
        if(deck == null)
            deck = createDeck();
        else if(deck.isEmpty())
        {
            System.out.print("\nDeck is empty! You must create and shuffle new deck of cards!\n\n");
            deck = createDeck();
        } // end else if()

        return deck;
    } // end checkDeck()

    private static Deck createDeck()
    {
        System.out.println("Creating deck...");
        Deck deck = new Deck(DECKSIZE);
        deck.createDeck();
        System.out.println("Shuffling deck...");
        deck.shuffleDeck();
        System.out.print("\n");

        return deck;
    } // end createDeck()

    private static Deck initialDraw(Deck deck)
    {
        for(int i = 0;i<playerCount;i++)
        {
            deck = drawFromDeck(deck, players.get(i));
            deck = drawFromDeck(deck, players.get(i));
        }
        deck = drawFromDeck(deck,dealersHand);
        deck = drawFromDeck(deck,dealersHand);
        System.out.print("\n");

        showHands();
        

        return deck;
    } // end initialDraw()

    private static void showHands()
    {
        System.out.print("Dealers Hand:");
        
        if(!isPlayerDone)
        {
            dealersHand.peek();
            System.out.print(" X_X = " + dealersHand.peekValue() + "\n");
        } // end if()
        else
        {
            dealersHand.displayHand();
            System.out.print(" = " + (dealersHand.getHandTotal() == BLACKJACK ? 
                    dealersHand.getHandTotal() + " : BLACKJACK!" : 
                    ((dealersHand.getHandTotal() > BLACKJACK) ? 
                    dealersHand.getHandTotal() + " : BUSTED!" : 
                    dealersHand.getHandTotal())) + "\n");
        } // end else
        
        
        for(int i = 0;i<playerCount;i++)
        {
            Hand player = players.get(i);
            System.out.print(player.getName()+"'s Hand:");
            player.displayHand();
            System.out.print(" = " + (player.getHandTotal() == BLACKJACK ? 
                player.getHandTotal() + " : BLACKJACK!" : 
                ((player.getHandTotal() > BLACKJACK) ? 
                player.getHandTotal() + " : BUSTED!" : 
                player.getHandTotal())) + "\n");
        }
        
        /*
        System.out.print("Players Hand:");
        player.displayHand();
        System.out.print(" = " + (player.getHandTotal() == BLACKJACK ? 
                player.getHandTotal() + " : BLACKJACK!" : 
                ((player.getHandTotal() > BLACKJACK) ? 
                player.getHandTotal() + " : BUSTED!" : 
                player.getHandTotal())) + "\n");

        if (split != null)
        {
            System.out.print("Players Hand:");
            split.displayHand();
            System.out.print(" = " + (split.getHandTotal() == BLACKJACK ? 
                    split.getHandTotal() + " : BLACKJACK!" : 
                    ((split.getHandTotal() > BLACKJACK) ? 
                    split.getHandTotal() + " : BUSTED!" : 
                    split.getHandTotal())) + "\n\n");
        } // end if()**/
        
            
    } // end showHands()
    
    private static void showHands(Hand player)
    {
        System.out.print(player.getName()+ "'s hand:");
        player.displayHand();
        System.out.print("\n");
    }
    private static String options() throws IOException
    {
        System.out.print("hit, split, stand, double, exit: ");
        InputStreamReader isr = new InputStreamReader(System.in);
        BufferedReader br = new BufferedReader(isr);
        String s = br.readLine();
        System.out.print("\n"); 
        return s;
    } // end options()
} // end BlackJack