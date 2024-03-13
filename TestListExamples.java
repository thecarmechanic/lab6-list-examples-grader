import static org.junit.Assert.*;
import org.junit.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

class IsMoon implements StringChecker {
  public boolean checkString(String s) {
    return s.equalsIgnoreCase("moon");
  }
}

public class TestListExamples {
  @Test(timeout = 500)
  public void testMergeRightEnd() {
    List<String> left = Arrays.asList("a", "b", "c");
    List<String> right = Arrays.asList("a", "d");
    List<String> merged = ListExamples.merge(left, right);
    List<String> expected = Arrays.asList("a", "a", "b", "c", "d");
    assertEquals(expected, merged);
  }

  @Test(timeout = 500)
    public void testMergeDiffOrder(){
        List<String> list1 = new ArrayList<>();
        list1.add("a");
        list1.add("c");

        List<String> list2 = new ArrayList<>();
        list2.add("b");
        list2.add("d");

        assertArrayEquals(new String[] {"a","b","c","d"}, ListExamples.merge(list2,list1).toArray());
    }

   @Test(timeout = 500)
    public void testFilter(){
        StringChecker minLen5Checker = new StringChecker() {
            public boolean checkString(String s){return s.length()>=5;}
        };
        List<String> input1 = new ArrayList<>();
        input1.add("Hi");
        input1.add("Hello");
        input1.add("Good Day");
        assertArrayEquals(new String[] {"Hello","Good Day"}, ListExamples.filter(input1, minLen5Checker).toArray());
    }
}
