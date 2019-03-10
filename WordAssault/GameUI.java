package WordAssault;


import javax.swing.*;
import java.awt.Rectangle;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.geom.Line2D;
import java.awt.*;
import java.awt.geom.*;
/**
 * Write a description of class GameUI here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class GameUI extends JComponent
{
    Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
    private int mWidth = (int)screenSize.getWidth();
    private int mHeight = (int)screenSize.getHeight();
    public void paintComponent(Graphics g)
    {
        Graphics2D g2 = (Graphics2D)g;
        g2.drawLine(0,mHeight-100,mWidth-200,mHeight-100);
        g2.drawLine(mWidth-200,0,mWidth-200,mHeight);
    }
}