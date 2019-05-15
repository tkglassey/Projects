import static org.junit.Assert.*;

import java.util.ArrayList;

import org.junit.Before;
import org.junit.Test;


public class MaxHeapTest
{
   private MaxHeap heap;


   @Before
   public void setUp() throws Exception
   {
      heap = new MaxHeap(10);
      heap.insert(new Student("Susan", 60, 3.5));
      heap.insert(new Student("Ben", 70, 3.4));
      heap.insert(new Student("Reed", 120, 4.0));
      heap.insert(new Student("Johnny", 50, 1.2));
   }

   @Test
   public void test()
   {
      assertEquals(4.0, heap.extractMax().gpa(), .000001);
      assertEquals(3.5, heap.extractMax().gpa(), .000001);
   }

}
