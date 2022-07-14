// Communication controller class
// Object for handling all communication between this program and other programs
// Currently only supports use with the GridMusic40 program



public class CommunicationController{
  
  
  public CommunicationController(){} // Empty constructor
  
  
  void sendMessage(){
    
    OscMessage myMessage = new OscMessage("/test");
    myMessage.add(123);
    oscP5.send(myMessage, myRemoteLocation);
  }
  
  
  void receiveMessage(OscMessage theOscMessage){
    int newGridWidth = theOscMessage.get(0).intValue();
    int newGridHeight = theOscMessage.get(1).intValue();
    adsr[0] = theOscMessage.get(2).floatValue(); 
    adsr[1] = theOscMessage.get(3).floatValue();
    adsr[2] = theOscMessage.get(4).floatValue();
    adsr[3] = theOscMessage.get(5).floatValue();
    int[] activeCellYCoordinates = new int[newGridWidth];
    for(int i = 0; i < newGridWidth; i++){
      activeCellYCoordinates[i] = theOscMessage.get(i+6).intValue();
    }
    println("GridWidth = " + newGridWidth);  
    println("GridHeight =  " + newGridHeight);    
    gridController.updateGridFromMessage(newGridWidth, newGridHeight, activeCellYCoordinates);
  }
  
  
  
}
