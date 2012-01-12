// This class maintains a delaunay triangulation of the Homebases and
// Asteroids of the Environment, so that computer AI opponents can
// make robust navigation decisions.
class NavigationMap
  {
  public var triangles:Array;	
  public var edges:Array;  
  
  public function NavigationMap()
    {
    triangles = new Array;	
    edges = new Array;    
    }
  
  public function whereIs (x:Body) : Triangle
    {
    var found:Number = -1;
	for (var t:Number = 0; t < triangles.length && (found==-1); t++)
	  if (GeometryTests.inTriangle(triangles[t], x) )
	      found = t;
	if (found != -1)      
      return triangles[found];
    else
      return null;  
    }
  
  public function insert(x:Body)
    {
    // Find which triangle this body is inside.    
    var found:Number = -1;
	for (var t:Number = 0; t < triangles.length && (found==-1); t++)
	  if (GeometryTests.inTriangle(triangles[t], x) )
	      found = t;
	// Can this ever happen?      
	if (found == -1)
	  return;
	
	// This is the part where YOU draw a sketch if you want to figure this out.
	var a:Body = triangles[found].A;
	var b:Body = triangles[found].B;
	var c:Body = triangles[found].C;	
		
    // Make new triangles.
    var t1:Triangle = new Triangle(a,x,c);    
    var t2:Triangle = new Triangle(a,b,x);
    var t3:Triangle = new Triangle(x,b,c);
    
    // Make new edges.
    var e1:Edge = new Edge(a,x);
    var e2:Edge = new Edge(b,x);
    var e3:Edge = new Edge(c,x);
    
    // Stitch edge pointers.
    e1.Tleft = t2;
    e1.Tright = t1;
    
    e2.Tleft = t3;
    e2.Tright = t2;
    
    e3.Tleft = t1;
    e3.Tright = t3;
    
    // Stitch triangle pointers.
    t1.edgeAB = e1;
    t1.edgeBC = e3;
    t1.edgeCA = triangles[found].edgeCA;
    
    t2.edgeAB = triangles[found].edgeAB;
    t2.edgeBC = e2;
    t2.edgeCA = e1;
    
    t3.edgeAB = e2;
    t3.edgeBC = triangles[found].edgeBC;
    t3.edgeCA = e3;
   
    e1.ID = edges.length;
    edges.push(e1);
    e2.ID = edges.length;
    edges.push(e2);
    e3.ID = edges.length;
    edges.push(e3);
    
    // Fix references on existing edges.
    if (triangles[found].edgeAB.Tleft == triangles[found])
      triangles[found].edgeAB.Tleft = t2;
    else 
      triangles[found].edgeAB.Tright = t2;
    
    if (triangles[found].edgeBC.Tleft == triangles[found])
      triangles[found].edgeBC.Tleft = t3;
    else 
      triangles[found].edgeBC.Tright = t3;
    
    if (triangles[found].edgeCA.Tleft == triangles[found])
      triangles[found].edgeCA.Tleft = t1;
    else 
      triangles[found].edgeCA.Tright = t1;   
        
    // Pitch old triangle.
    triangles[found] = triangles[triangles.length-1];
    triangles[found].ID = found;
    triangles.pop();
    
    
    // Push all this data in.    
    t1.ID = triangles.length;
    triangles.push(t1);
        
    t2.ID = triangles.length;
    triangles.push(t2);
        
    t3.ID = triangles.length;
    triangles.push(t3);                      
    }
    
  public function computeAngles() : Boolean
    {
    var returnValue = false;	
    for (var t:Number = 0; t < triangles.length; t++)	
      {
      triangles[t].computeAngles();		    
      triangles[t].ID = t;            
      }
    return returnValue;  
    }
    
  public function draw()  
    {    
    _root.lineStyle(2, 0x006400, 100);	  
    /*
    for (var t:Number = 0; t < triangles.length; t++)
      {    
      var alpha:Number = 1.0;
      var cx:Number = (triangles[t].A.rx + triangles[t].B.rx + triangles[t].C.rx)/3.0;
      var cy:Number = (triangles[t].A.ry + triangles[t].B.ry + triangles[t].C.ry)/3.0;      
      _root.moveTo(alpha * triangles[t].A.rx + (1-alpha) * cx, alpha * triangles[t].A.ry + (1-alpha) * cy );
      _root.lineTo(alpha * triangles[t].B.rx + (1-alpha) * cx, alpha * triangles[t].B.ry + (1-alpha) * cy );
      _root.lineTo(alpha * triangles[t].C.rx + (1-alpha) * cx, alpha * triangles[t].C.ry + (1-alpha) * cy );
      _root.lineTo(alpha * triangles[t].A.rx + (1-alpha) * cx, alpha * triangles[t].A.ry + (1-alpha) * cy );      
      var junk:MovieClip = _root.createEmptyMovieClip (""+_root.getNextHighestDepth(),_root.getNextHighestDepth());
      junk.createTextField("thetext",1, cx, cy, 25, 25);      
      junk.thetext.text = ""+t;      
      }
    */
      
    for (var e:Number = 0; e < edges.length; e++)
      {     
      _root.moveTo(edges[e].B1.rx,edges[e].B1.ry);	
      _root.lineTo(edges[e].B2.rx,edges[e].B2.ry);	        
      /*
      var cx:Number = (edges[e].B1.rx+edges[e].B2.rx)/2.0;
      var cy:Number = (edges[e].B1.ry+edges[e].B2.ry)/2.0;
      var junk:MovieClip = _root.createEmptyMovieClip (""+_root.getNextHighestDepth(),_root.getNextHighestDepth());
      junk.createTextField("thetext",1, cx, cy, 25, 25);      
      junk.thetext.text = ""+e;
      */
      }    
    }
  
  public function cleanUp ()
    {
    var flippedAnEdge:Boolean = true;
    while (flippedAnEdge)
      {
      flippedAnEdge	= false;
      for (var e:Number = 0; e < edges.length; e++)
        if (attemptFlip(e) )
          flippedAnEdge = true;
      }
    }
  
  public function attemptFlip (e:Number) : Boolean
    {
    // If an edge is not supported by two triangles, not flippable.
    if (edges[e].Tleft == null)
      return false;
    if (edges[e].Tright == null)
      return false;     
   
    // Rotate triangles such that this edge is "edgeAB" for both triangles.
    // Tleft.
    if (edges[e].Tleft.edgeBC == edges[e])
      edges[e].Tleft.rotate(1);
    else if (edges[e].Tleft.edgeCA == edges[e])
      edges[e].Tleft.rotate(-1);
    // Tright.
    if (edges[e].Tright.edgeBC == edges[e])
      edges[e].Tright.rotate(1);
    else if (edges[e].Tright.edgeCA == edges[e])
      edges[e].Tright.rotate(-1);
      
    // Check that the quadrilateral is convex.
    var b1:Body = edges[e].Tright.C;
    var b2:Body = edges[e].Tright.B;
    var b3:Body = edges[e].Tleft.C;
        
    var turn1ok:Boolean = GeometryTests.isRightTurn (b1,b2,b3);
    
    b1 = edges[e].Tleft.C;
    b2 = edges[e].Tleft.B;
    b3 = edges[e].Tright.C;
    
    var turn2ok:Boolean = GeometryTests.isRightTurn (b1,b2,b3);
    
    if (turn1ok && turn2ok)
      {      
      // Figure out if a flip improves triangle.
      var t1new:Triangle = new Triangle(edges[e].Tleft.C, edges[e].Tleft.A, edges[e].Tright.C);
      t1new.computeAngles();
      var t2new:Triangle = new Triangle(edges[e].Tright.C, edges[e].Tright.A, edges[e].Tleft.C);
      t2new.computeAngles();
      
      var existingQuality = Math.min (edges[e].Tleft.minAngle, edges[e].Tright.minAngle);
      var newQuality = Math.min (t1new.minAngle, t2new.minAngle);      

      // Time to flip.
      if (newQuality > existingQuality)
        {        
        // Fix the edge references on t1new.
        t1new.edgeAB = edges[e].Tleft.edgeCA;
        t1new.edgeBC = edges[e].Tright.edgeBC;
        t1new.edgeCA = edges[e];        
        
        // Fix the edge references on t2new.
        t2new.edgeAB = edges[e].Tright.edgeCA;
        t2new.edgeBC = edges[e].Tleft.edgeBC;
        t2new.edgeCA = edges[e];
        
        var oldTleft = edges[e].Tleft.ID;
        var oldTright = edges[e].Tright.ID;        
        
        // Fix the triangle references on edges associated with the old Tright.                
        if (edges[e].Tright.edgeBC.Tleft == edges[e].Tright)
          edges[e].Tright.edgeBC.Tleft = triangles[oldTleft];
        else
          edges[e].Tright.edgeBC.Tright = triangles[oldTleft]; 
        
        if (edges[e].Tright.edgeCA.Tleft == edges[e].Tright)
          edges[e].Tright.edgeCA.Tleft = triangles[oldTright];
        else
          edges[e].Tright.edgeCA.Tright = triangles[oldTright];
        
        // Fix the triangle references on edges associated with the old Tleft.        
        if (edges[e].Tleft.edgeBC.Tleft == edges[e].Tleft)
          edges[e].Tleft.edgeBC.Tleft =triangles[oldTright];
        else
          edges[e].Tleft.edgeBC.Tright = triangles[oldTright];
        
        if (edges[e].Tleft.edgeCA.Tleft == edges[e].Tleft)
          edges[e].Tleft.edgeCA.Tleft = triangles[oldTleft];
        else
          edges[e].Tleft.edgeCA.Tright = triangles[oldTleft];        
        
        // Flip the edge.
        edges[e].B1 = edges[e].Tleft.C;
        edges[e].B2 = edges[e].Tright.C;
                
        // Add the new triangles - overwrite the old values.
        triangles[oldTleft].A = t1new.A;
        triangles[oldTleft].B = t1new.B;
        triangles[oldTleft].C = t1new.C;
        triangles[oldTleft].edgeAB = t1new.edgeAB;
        triangles[oldTleft].edgeBC = t1new.edgeBC;
        triangles[oldTleft].edgeCA = t1new.edgeCA;
        triangles[oldTleft].angleA = t1new.angleA;
        triangles[oldTleft].angleB = t1new.angleB;
        triangles[oldTleft].angleC = t1new.angleC;
        triangles[oldTleft].minAngle = t1new.minAngle;
        
        triangles[oldTright].A = t2new.A;
        triangles[oldTright].B = t2new.B;
        triangles[oldTright].C = t2new.C;
        triangles[oldTright].edgeAB = t2new.edgeAB;
        triangles[oldTright].edgeBC = t2new.edgeBC;
        triangles[oldTright].edgeCA = t2new.edgeCA;
        triangles[oldTright].angleA = t2new.angleA;
        triangles[oldTright].angleB = t2new.angleB;
        triangles[oldTright].angleC = t2new.angleC;
        triangles[oldTright].minAngle = t2new.minAngle;           
        return true;
        }
      }
    return false;
    }
    
  }