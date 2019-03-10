package WordAssault;


import javax.swing.*;
import java.awt.Rectangle;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.geom.Line2D;
import java.awt.*;
import java.awt.geom.*;
/**
 * Write a description of class FallingWord here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */

public class FallingWord extends JLabel
{
    private String word;
    private int xLocation;
    private double yLocation;
    private double yEnd;
    private double time; //how many times 10 miliseconds will go before the word hits the bottom
    /*public FallingWord(int x, int end)
    {
        WordBank dummy = new WordBank();
        super(dummy.chooseWord());
        xLocation = x;
        double yLocation = 400;
        yEnd = end;
        time = ((word.length()+2)*100);
    }*/
    public FallingWord(String aWord, int x, int end, double aTime)
    {
        super(aWord);
        word=aWord;
        xLocation = x;
        double yLocation = 0;
        yEnd = end;
        time = (aTime*100);
        super.setBounds(xLocation,(int)yLocation,word.length()*10,20);
    }
    
    public void update()
    {
        double move = yEnd/time;
        yLocation += move;
        
        super.setBounds(xLocation,(int)yLocation,word.length()*10,20);
    }
    
    public boolean equals(String entered)
    {
        return (entered.equalsIgnoreCase(word));
    }
    
    public boolean equals(FallingWord entered)
    {
        return(word.equals(entered.getWord()));
    }
    
    public int scoreValue()
    {
        return (100*(word.length()-2));
    }
    
    public double getYLocation()
    { return yLocation;}
    
    public String getWord()
    {
        return word;
    }
}







