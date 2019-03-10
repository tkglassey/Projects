package WordAssault;


import java.util.*;
import javax.swing.*;
import java.awt.*;
import java.awt.Component.*;
import javax.swing.*;
import java.awt.event.*;
import java.util.Timer;
import java.util.TimerTask;
/**
 * Write a description of class WordAssault here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class WordAssault implements ActionListener 
{
    private JFrame frame = new JFrame();
    private JTextField textField;
    private JLabel lblGreeting;
    private ArrayList<FallingWord> currentWords;
    private WordBank bank = new WordBank();
    Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
    private int mWidth = (int)screenSize.getWidth()-200;
    private int mHeight = (int)screenSize.getHeight()-100;
    private GameUI ui = new GameUI();
    private int lives=3;
    private int score;
    JLabel lifeLabel;
    JLabel scoreLabel;
    JLabel levelLabel;
    JLabel pauseLabel;
    JLabel gameOver = new JLabel("<html>      Game Over!<br>Type go to start new game.</html>");
    JLabel instructions= new JLabel("<html>Type the word before it hits the ground.<br>Type 'pause' to stop time until you enter something<br>When a new level starts, as long as the level is on the screen, no others will spawn. It is still a word.<br>Type 'go' to start new game.</html>");
    private boolean devPause;
    private int time;
    private double level;
    private int pauses;
    private boolean gameRunning;
    Timer timer;
    
    
    public static void main(String[] args)
    {
        WordAssault game = new WordAssault();
        game.startGame();
    }
    
    public void actionPerformed(ActionEvent evt)
    {
        String text = textField.getText();
        for(int i = currentWords.size()-1; i>=0;i--)
        {
            if(currentWords.get(i).equals(text))
            {
                score+=currentWords.get(i).scoreValue();
                frame.remove(currentWords.remove(i));
                frame.remove(scoreLabel);
                scoreLabel.setText("Score: "+score);
                frame.add(scoreLabel);
            }
        }
        if(pauses>0&&text.equalsIgnoreCase("pause"))
        {
            devPause = true;
            frame.remove(pauseLabel);
            pauses=pauses -1;
            pauseLabel.setText("Pauses: "+pauses);
            frame.add(pauseLabel);
        }
        else
        {
            devPause = false;
        }
        if(gameRunning==false && text.equalsIgnoreCase("go"))
        {
            frame.remove(lifeLabel);
            frame.remove(scoreLabel);
            frame.remove(levelLabel);
            frame.remove(pauseLabel);
            frame.remove(gameOver);
            frame.remove(instructions);
            runGame();
        }
        if(text.equalsIgnoreCase("slit wrist"))
        {
            frame.remove(lifeLabel);
            lives=1;
            lifeLabel.setText("Lives: "+lives);
            frame.add(lifeLabel);
        }
        frame.repaint();
        textField.setText("");
        
    }
    
    public WordAssault()
    {  
        frame.setTitle("Word Assault");
        frame.setVisible(true);
        frame.setExtendedState(JFrame.MAXIMIZED_BOTH);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLayout(null);
        ui.setBounds(0,0,mWidth+200,mHeight+100);
        frame.add(ui);
        currentWords = new ArrayList<>();
        //currentWords.add(new FallingWord("Superman",200, 768));
        for(int i = 0;i<currentWords.size();i++)
        {
            currentWords.get(i).setVisible(true);
            frame.add(currentWords.get(i));
            
        }
        textField = new JTextField();
        textField.addActionListener(this);
        textField.setBounds(600,680,200,20);
        textField.setVisible(true);
        frame.add(textField);
        frame.repaint();
    }
    
    public void runGame()
    {
        gameRunning = true;
        lives=3;
        level = 1;
        pauses = 3;
        score = 0;
        lifeLabel = new JLabel("Lives: "+lives);
        scoreLabel = new JLabel("Score: "+score);
        levelLabel = new JLabel("Level: "+level);
        pauseLabel = new JLabel("Pauses: "+pauses);
        lifeLabel.setBounds(mWidth+20,80,120,20);
        scoreLabel.setBounds(mWidth+20,120,140,20);
        levelLabel.setBounds(mWidth+20,40,120,20);
        pauseLabel.setBounds(mWidth+20,160,120,20);
        frame.add(lifeLabel);
        frame.add(scoreLabel);
        frame.add(levelLabel);
        frame.add(pauseLabel);
        currentWords.add(new FallingWord("Level 1",700,mHeight, 8));
        timer = new Timer();
        timer.schedule(new GameUpdater(), 0, 10);
        
        
    }
    class GameUpdater extends TimerTask
    {
        public void run()
        {
            for(int i = currentWords.size()-1;i>=0;i--)
            {
                FallingWord temp = currentWords.get(i);
                frame.remove(temp);
                if(devPause!=true)
                {
                    temp.update();
                }
                if(temp.getYLocation() >= (mHeight-15))
                {   
                    frame.remove(lifeLabel);
                    lives=lives -1;
                    lifeLabel.setText("Lives: "+lives);
                    frame.add(lifeLabel);
                    currentWords.remove(i);
                    if(lives==0)
                    {
                        gameRunning = false;
                        endGame();
                        timer.cancel();
                        return;
                    }
                }
                else if(i<currentWords.size()&&temp.equals(currentWords.get(i)))
                {
                    frame.add(temp);
                }
                frame.repaint();
            }
            if(devPause!=true)
            {
                time++;
                double rnd = Math.random();
                if(currentWords.size()>0 && currentWords.get(currentWords.size()-1).getWord().indexOf("Level")>=0)
                {}
                else if(time%3000==0)
                {
                    level++;
                    FallingWord created = new FallingWord("Level "+(int)level,700,mHeight, 8);
                    currentWords.add(created);
                    frame.remove(levelLabel);
                    levelLabel.setText("Level: "+(int)level);
                    frame.add(levelLabel);
                }
                else if(time/3000==1 && time%3000==2400)
                {
                    FallingWord created = new FallingWord("Supercalifragilisticexpialidocious",700,mHeight, 36);
                    currentWords.add(created);
                }
                else if(rnd<(.1-((.001*currentWords.size())*(100.0/level))))
                {
                    String str = bank.choseWord();
                    FallingWord created = new FallingWord(str,(int)(Math.random()*(mWidth-str.length()*10)),mHeight, (str.length()+(2.0/(.5+(level/2.0)))));
                    currentWords.add(created); 
                }
            }
            if(gameRunning==false)
            {
                endGame();
                timer.cancel();
            }
        }
    }
    public void endGame()
    {
        //frame.remove(textField);
        
        gameOver.setBounds(660,350,200,40);
        gameOver.setForeground(Color.red);
        frame.add(gameOver);
        for(int i = currentWords.size()-1;i>=0;i--)
        {
            FallingWord temp = currentWords.get(i);
            frame.remove(temp);
            currentWords.remove(i);
        }
        frame.repaint();
    }
    
    public void startGame()
    {
        gameRunning=false;
        lives=3;
        level = 1;
        pauses = 3;
        score = 0;
        lifeLabel = new JLabel("Lives: "+lives);
        scoreLabel = new JLabel("Score: "+score);
        levelLabel = new JLabel("Level: "+level);
        pauseLabel = new JLabel("Pauses: "+pauses);
        lifeLabel.setBounds(mWidth+20,80,120,20);
        scoreLabel.setBounds(mWidth+20,120,140,20);
        levelLabel.setBounds(mWidth+20,40,120,20);
        pauseLabel.setBounds(mWidth+20,160,120,20);
        frame.add(lifeLabel);
        frame.add(scoreLabel);
        frame.add(levelLabel);
        frame.add(pauseLabel);
        instructions.setBounds((mWidth)/2,(mHeight)/2,200,200);
        frame.add(instructions);
    }
}
