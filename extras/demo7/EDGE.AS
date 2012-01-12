// Primitive for representing edges - holds the two bodies that makeup the edge,
// as well as the two triangles that border it (which might be null).
class Edge
  {   
  var B1:Body;
  var B2:Body;  	  
  	
  var Tleft:Triangle;
  var Tright:Triangle;
  
  var ID:Number;
  
  public function Edge (b1:Body, b2:Body)
    {
    B1 = b1;
    B2 = b2;	
    	
    Tleft = null;
    Tright = null;    
    ID = -1;
    }
  }