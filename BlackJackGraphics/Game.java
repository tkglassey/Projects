
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.util.*;

public class Game extends JFrame implements ActionListener {

    private Deck deck;
    private ArrayList<Player> players;
    private int currentPlayer;
    private JPanel[] statusPanels;
    private JPanel[] playerPanels;
    private JLabel[] statuses;
    private int splits;
    /*public Player player = new Player("Player 1");*/
    
    public Player dealer = new Player("dealer");

    private JButton jbtnHit = new JButton("Hit");
    private JButton jbtnStay = new JButton("Stay");
    private JButton jbtnDeal = new JButton("Deal");
    private JButton jbtnDouble = new JButton("Double");
    private JButton jbtnAddPlayer = new JButton("Add Player");
    private JButton jbtnRemovePlayer = new JButton("Remove Player");
    private JButton jbtnSplit = new JButton("Split");

    private JLabel[] status;
    private String[] statusText;

    JPanel playerPanel = new JPanel();
    //JPanel playerPanel2 = new JPanel();
    JPanel dealerPanel = new JPanel();
    JPanel buttonsPanel = new JPanel();
    JPanel blankPanel = new JPanel();
    JPanel blankSpace = new JPanel();

    Game() {
        statusPanels = new JPanel[8];
        playerPanels = new JPanel[8];
        statuses = new JLabel[8];
        status = new JLabel[4];
        statusText = new String[4];
        for(int i = 0;i<4;i++)
        {
            status[i]= new JLabel("");
            status[i].setText("Waiting");
            statusText[i]= new String("");
        }
        
        players = new ArrayList<Player>();
        currentPlayer = 0;
        Player first = new Player("Player 1");
        addPlayer(first);
        JFrame gameFrame = new JFrame("IT327 Project 4 - BlackJack");
        gameFrame.setIconImage(Toolkit.getDefaultToolkit().getImage("cards/10.png"));
        gameFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        
        for(int i = 0;i<8;i++)
        {
            playerPanels[i] = new JPanel();
            statusPanels[i] = new JPanel();
            playerPanels[i].setBackground(Color.BLUE);
            statusPanels[i].setBackground(Color.RED);
            statuses[i] = new JLabel();
            statuses[i].setText("Player "+(i+1));
            if(i>=4)
            {
                statuses[i].setText(""/*"Player "+(i+1)+"'s split"*/);
            }
            statusPanels[i].add(statuses[i]);
        }
        
        buttonsPanel.add(jbtnDouble);
        buttonsPanel.add(jbtnHit);
        buttonsPanel.add(jbtnStay);
        buttonsPanel.add(jbtnDeal);
        buttonsPanel.add(jbtnRemovePlayer);
        buttonsPanel.add(jbtnAddPlayer);
        buttonsPanel.add(jbtnSplit);
        blankPanel.setLayout(new GridLayout(4,1,0,0));
        blankPanel.add(status[0]);
        blankPanel.add(status[1]);
        blankPanel.add(status[2]);
        blankPanel.add(status[3]);

        jbtnHit.addActionListener(this);
        jbtnStay.addActionListener(this);
        jbtnDeal.addActionListener(this);
        jbtnDouble.addActionListener(this);
        jbtnAddPlayer.addActionListener(this);
        jbtnRemovePlayer.addActionListener(this);
        jbtnSplit.addActionListener(this);

        jbtnHit.setEnabled(false);
        jbtnStay.setEnabled(false);
        jbtnDouble.setEnabled(false);
        jbtnSplit.setEnabled(false);
        //jbtnRemovePlayer.setEnabled(false);
        //jbtnAddPlayer.setEnabled(false);

        dealerPanel.setBackground(Color.GREEN);
        playerPanel.setBackground(Color.GREEN);
        //playerPanel2.setBackground(Color.GREEN);
        buttonsPanel.setBackground(Color.GREEN);
        blankPanel.setBackground(Color.GREEN);
        blankSpace.setBackground(Color.GREEN);

        gameFrame.setLayout(new GridLayout(5,4,0,0));
        gameFrame.add(dealerPanel);
        gameFrame.add(blankSpace);
        gameFrame.add(buttonsPanel);
        gameFrame.add(blankPanel);
        gameFrame.add(statuses[0]);
        gameFrame.add(statuses[1]);
        gameFrame.add(statuses[2]);
        gameFrame.add(statuses[3]);
        gameFrame.add(playerPanels[0]);
        gameFrame.add(playerPanels[1]);
        gameFrame.add(playerPanels[2]);
        gameFrame.add(playerPanels[3]);
        gameFrame.add(statuses[4]);
        gameFrame.add(statuses[5]);
        gameFrame.add(statuses[6]);
        gameFrame.add(statuses[7]);
        gameFrame.add(playerPanels[4]);
        gameFrame.add(playerPanels[5]);
        gameFrame.add(playerPanels[6]);
        gameFrame.add(playerPanels[7]);
        gameFrame.repaint();
        gameFrame.setSize(1300, 700);
        gameFrame.setVisible(true);
    }
    
    private void split(Player temp){
        Player split = new Player(temp.getName()+"'s Split");
        split.reset();
        Card newCard = split.dealTo(temp.dealFrom());
        players.set(currentPlayer,temp);
        players.add(split);
        playerPanels[currentPlayer].removeAll();
        playerPanels[currentPlayer].add(new JLabel(new ImageIcon("cards/" + temp.cards[0].toString())));
        playerPanels[currentPlayer].updateUI();
        playerPanels[players.size()-1].add(new JLabel(new ImageIcon("cards/" + newCard)));
        playerPanels[players.size()-1].updateUI();
        hitPlayer(temp);
        players.set(currentPlayer,temp);
        int dummy = currentPlayer;
        currentPlayer = players.size()-1;
        hitPlayer(split);
        players.set(currentPlayer,split);
        currentPlayer = dummy;
        splits++;
    }

    private void hitPlayer(Player temp) {
        Card newCard = temp.dealTo(deck.dealFrom());
        playerPanels[currentPlayer].add(new JLabel(new ImageIcon("cards/" + newCard.toString())));
        playerPanels[currentPlayer].updateUI();
        players.set(currentPlayer,temp);
    }

    private void hitDealerDown() {
        Card newCard = dealer.dealTo(deck.dealFrom());
        dealerPanel.add(new JLabel(new ImageIcon("cards/b2fv.png")));
        dealerPanel.updateUI();
    }

    private void hitDealer() {
        Card newCard = dealer.dealTo(deck.dealFrom());
        dealerPanel.add(new JLabel(new ImageIcon("cards/" + newCard.toString())));
        dealerPanel.updateUI();
    }

    private void deal() {
        for(int i = 0; i<8;i++)
        {
            playerPanels[i].removeAll();
            playerPanels[i].updateUI();
        }
        for(int i = 0; i<players.size();i++)
        {
            Player temp = players.get(i);
            temp.reset();
            players.set(i,temp);
        }
        dealerPanel.removeAll();
        dealerPanel.updateUI();
        dealer.reset();
        if (deck == null || deck.size() < 15) {
            deck = new Deck();
            deck.shuffle();
        }
        currentPlayer = 0;
        for(int i = 0; i<players.size();i++)
        {
            hitPlayer(players.get(i));
            hitPlayer(players.get(i));
            currentPlayer++;
        }
        currentPlayer = 0;
        hitDealerDown();
        hitDealer();
    }

    private void checkWinner() {
        dealerPanel.removeAll();
        
        for (int i = 0; i < dealer.inHand(); i++) {
            dealerPanel.add(new JLabel(new ImageIcon("cards/" + dealer.cards[i].toString())));
        }
        for(int i = 0; i<players.size();i++)
        {
            Player temp = players.get(i);
            if (temp.value() > 21) {
                statusText[i%4]+= temp.getName()+" Busts    ";
                status[i%4].setText(statusText[i%4]);
            } else if (dealer.value() > 21) {
                statusText[i%4]+= "Dealer Busts    ";
                status[i%4].setText(statusText[i%4]);
            } else if (dealer.value() == temp.value()) {
                statusText[i%4]+=temp.getName()+" Pushes    ";
                status[i%4].setText(statusText[i%4]);
            } else if (dealer.value() < temp.value()) {
                statusText[i%4]+= temp.getName()+" Wins    ";
                status[i%4].setText(statusText[i%4]);
            } else {
                statusText[i%4]+= "Dealer Beats "+temp.getName()+"    ";
                status[i%4].setText(statusText[i%4]);
            }
            blankPanel.updateUI();
        }
        for(int i =0; i<splits;i++)
        {
            players.remove(players.size()-1);
        }
        splits= 0;
    }
    
    private void addPlayer(Player temp)
    {
       players.add(temp); 
    }

    public void actionPerformed(ActionEvent e) {
        if (e.getSource() == jbtnHit) {
            hitPlayer(players.get(currentPlayer));
            jbtnSplit.setEnabled(false);
            jbtnDouble.setEnabled(false);
            if(players.get(currentPlayer).value()>=21)
            {
                if(currentPlayer!=players.size()-1)
                {
                    currentPlayer++;
                    jbtnSplit.setEnabled(true);
                }
                else
                {
                    while (dealer.value() < 17) {
                        hitDealer();
                    }
                    checkWinner();
                    jbtnHit.setEnabled(false);
                    jbtnSplit.setEnabled(false);
                    jbtnStay.setEnabled(false);
                    jbtnDouble.setEnabled(false);
                    jbtnDeal.setEnabled(true);
                    jbtnAddPlayer.setEnabled(true);
                    jbtnRemovePlayer.setEnabled(true);
                    if(players.size()<=1)
                    {
                        jbtnRemovePlayer.setEnabled(false);
                    }
                    if(players.size()>=4)
                    {
                        jbtnAddPlayer.setEnabled(false);
                    }
                }
            }
        }
        
        if (e.getSource() == jbtnSplit) {
            Player temp = players.get(currentPlayer);
            if(temp.inHand()==2 && temp.cards[0].getRank()==temp.cards[1].getRank() && currentPlayer<4)
            {
                split(temp);
            }
            jbtnSplit.setEnabled(false);
        }
        
        if(e.getSource() == jbtnDouble)
        {
            Player temp = players.get(currentPlayer);
            if(temp.inHand()==2)
            {
                hitPlayer(players.get(currentPlayer));
                if(currentPlayer!=players.size()-1)
                {
                    currentPlayer++;
                    jbtnSplit.setEnabled(true);
                }
                else
                {
                    while (dealer.value() < 17) {
                        hitDealer();
                    }
                    checkWinner();
                    jbtnHit.setEnabled(false);
                    jbtnStay.setEnabled(false);
                    jbtnSplit.setEnabled(false);
                    jbtnDouble.setEnabled(false);
                    jbtnDeal.setEnabled(true);
                    jbtnAddPlayer.setEnabled(true);
                    jbtnRemovePlayer.setEnabled(true);
                    if(players.size()<=1)
                    {
                        jbtnRemovePlayer.setEnabled(false);
                    }
                    if(players.size()>=4)
                    {
                        jbtnAddPlayer.setEnabled(false);
                    }
                }
            }
        }

        if (e.getSource() == jbtnStay) {
            
            if(currentPlayer!=players.size()-1)
            {
                currentPlayer++;
                jbtnSplit.setEnabled(true);
            }
            else
            {
                while (dealer.value() < 17) {
                    hitDealer();
                }
                checkWinner();
                jbtnHit.setEnabled(false);
                jbtnSplit.setEnabled(false);
                jbtnStay.setEnabled(false);
                jbtnDouble.setEnabled(false);
                jbtnDeal.setEnabled(true);
                jbtnAddPlayer.setEnabled(true);
                jbtnRemovePlayer.setEnabled(true);
                if(players.size()<=1)
                {
                    jbtnRemovePlayer.setEnabled(false);
                }
                if(players.size()>=4)
                {
                    jbtnAddPlayer.setEnabled(false);
                }
            }
        }
        
        if(e.getSource() == jbtnRemovePlayer)
        {
            players.remove(players.size()-1);
            jbtnAddPlayer.setEnabled(true);
            if(players.size()<=1)
            {
                jbtnRemovePlayer.setEnabled(false);
            }
        }
        
        if(e.getSource() == jbtnAddPlayer)
        {
            Player player = new Player("Player "+(players.size()+1));
            addPlayer(player);
            jbtnRemovePlayer.setEnabled(true);
            if(players.size()>=4)
            {
                jbtnAddPlayer.setEnabled(false);
            }
        }

        if (e.getSource() == jbtnDeal) {
            deal();
            for(int i = 0;i<4;i++)
            {
                status[i].setText(" ");
                statusText[i]= new String("");
            }
            jbtnHit.setEnabled(true);
            jbtnStay.setEnabled(true);
            jbtnDeal.setEnabled(false);
            jbtnSplit.setEnabled(true);
            jbtnDouble.setEnabled(true);
            jbtnAddPlayer.setEnabled(false);
            jbtnRemovePlayer.setEnabled(false);
        }
    }

    public static void main(String[] args) {
        
        new Game();
    }
}


