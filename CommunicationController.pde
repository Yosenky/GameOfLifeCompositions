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
    int[] activeCellYCoordinates = new int[newGridWidth];
    for(int i = 0; i < newGridWidth; i++){
      activeCellYCoordinates[i] = theOscMessage.get(i+2).intValue();
    }
    println("GridWidth = " + newGridWidth);
    println("GridHeight =  " + newGridHeight);    
    gridController.updateGridFromMessage(newGridWidth, newGridHeight, activeCellYCoordinates);
  }
  
  
  
}
