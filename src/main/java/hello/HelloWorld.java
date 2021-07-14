package src.main.java.hello;

public class HelloWorld {
	public static void main(String[] args) {
		System.out.println("Hello, World!"); 
		String disp = "";
		for(int i=0; i<31 ; i++)
		    disp = disp + Integer.toString(i);
		System.out.println(disp); 
		System.out.println(disp.toString());   
		String name = "John Doe";
		String test = name.toString();
		System.out.println(test);
	}
}
