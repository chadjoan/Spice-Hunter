package {

import flash.display.Sprite;
import flash.text.TextField;

// This class maintains a delaunay triangulation of the Homebases and
// Asteroids of the Environment, so that computer AI opponents can
// make robust navigation decisions.
public class NavigationMap
  {
  public var triangles:Array;	
  public var edges:Array;  
  public var graph:Array;
  public var dual_nodes_x:Array;
  public var dual_nodes_y:Array;
  
  public function NavigationMap()
    {
    triangles = new Array;	
    edges = new Array;  
    graph = null;  
    }
  
  public function computeDualPositions () : void
    {
     // Compute dual node positions - intersection of perpendicular bisectors.
    var swap:Number;
    dual_nodes_x = new Array;	
    dual_nodes_y = new Array;	
    for (var t:Number=0; t < triangles.length; t++)	
      {
      // Centroid p0. 	
      var p0_x:Number = 0.5*triangles[t].A.rx + 0.5*triangles[t].B.rx;
      var p0_y:Number = 0.5*triangles[t].A.ry + 0.5*triangles[t].B.ry;      
      // Bisector unit vector, phat
      var phat_x:Number = triangles[t].B.rx - triangles[t].A.rx;
      var phat_y:Number = triangles[t].B.ry - triangles[t].A.ry;
      // Normalize.
      var phat_L:Number = Math.sqrt (phat_x*phat_x + phat_y*phat_y);
      phat_x /= phat_L;
      phat_y /= phat_L;
      // Rotate 90 degrees to get a normal.
      swap = phat_y;
      phat_y = -phat_x;
      phat_x = swap;
      
      // Centroid q0.
      var q0_x:Number = 0.5 *triangles[t].B.rx + 0.5*triangles[t].C.rx;
      var q0_y:Number = 0.5 *triangles[t].B.ry + 0.5*triangles[t].C.ry;      
      // Bisector unit vector, qhat
      var qhat_x:Number = triangles[t].C.rx - triangles[t].B.rx;
      var qhat_y:Number = triangles[t].C.ry - triangles[t].B.ry;
      // Normalize.
      var qhat_L:Number = Math.sqrt (qhat_x*qhat_x + qhat_y*qhat_y);
      qhat_x /= qhat_L;
      qhat_y /= qhat_L;
      // Rotate 90 degrees to get a normal.
      swap = qhat_y;
      qhat_y = -qhat_x;
      qhat_x = swap;   
      
      // Compute alpha, beta, gamma.
      var alpha:Number = qhat_x * (p0_x - q0_x) + qhat_y*(p0_y - q0_y);
      var pq:Number = phat_x*qhat_x + phat_y*qhat_y
      var beta:Number = pq * ( phat_x * (p0_x - q0_x) + phat_y*(p0_y - q0_y) );      
      var gamma:Number = 1 - pq*pq;
      // Compute v.
      var v:Number = (alpha - beta) / gamma;
      // Compute dual node position.
      dual_nodes_x[t] = q0_x + qhat_x * v;
      dual_nodes_y[t] = q0_y + qhat_y * v;         
      }		
    }
  
  public function makeDualGraph() : void
    {    
    // Compute dual node positions - intersection of perpendicular bisectors.
    var swap:Number;
    dual_nodes_x = new Array;	
    dual_nodes_y = new Array;	
    for (var t:Number=0; t < triangles.length; t++)	
      {
      // Centroid p0. 	
      var p0_x:Number = 0.5*triangles[t].A.rx + 0.5*triangles[t].B.rx;
      var p0_y:Number = 0.5*triangles[t].A.ry + 0.5*triangles[t].B.ry;      
      // Bisector unit vector, phat
      var phat_x:Number = triangles[t].B.rx - triangles[t].A.rx;
      var phat_y:Number = triangles[t].B.ry - triangles[t].A.ry;
      // Normalize.
      var phat_L:Number = Math.sqrt (phat_x*phat_x + phat_y*phat_y);
      phat_x /= phat_L;
      phat_y /= phat_L;
      // Rotate 90 degrees to get a normal.
      swap = phat_y;
      phat_y = -phat_x;
      phat_x = swap;
      
      // Centroid q0.
      var q0_x:Number = 0.5 *triangles[t].B.rx + 0.5*triangles[t].C.rx;
      var q0_y:Number = 0.5 *triangles[t].B.ry + 0.5*triangles[t].C.ry;      
      // Bisector unit vector, qhat
      var qhat_x:Number = triangles[t].C.rx - triangles[t].B.rx;
      var qhat_y:Number = triangles[t].C.ry - triangles[t].B.ry;
      // Normalize.
      var qhat_L:Number = Math.sqrt (qhat_x*qhat_x + qhat_y*qhat_y);
      qhat_x /= qhat_L;
      qhat_y /= qhat_L;
      // Rotate 90 degrees to get a normal.
      swap = qhat_y;
      qhat_y = -qhat_x;
      qhat_x = swap;   
      
      // Compute alpha, beta, gamma.
      var alpha:Number = qhat_x * (p0_x - q0_x) + qhat_y*(p0_y - q0_y);
      var pq:Number = phat_x*qhat_x + phat_y*qhat_y
      var beta:Number = pq * ( phat_x * (p0_x - q0_x) + phat_y*(p0_y - q0_y) );      
      var gamma:Number = 1 - pq*pq;
      // Compute v.
      var v:Number = (alpha - beta) / gamma;
      // Compute dual node position.
      dual_nodes_x[t] = q0_x + qhat_x * v;
      dual_nodes_y[t] = q0_y + qhat_y * v;         
      }	
      
    graph = new Array;	
    for (t = 0; t < triangles.length; t++)
      graph[t] = new Array;    	
    // Add edges to the dual graph, 1:1 correspondence to "edges".
    for (var e:Number=0; e < edges.length; e++)      
      // Is this edge supported between two triangles?
      if (edges[e].Tleft != null && edges[e].Tright != null)	
        {
        var start:Number = edges[e].Tleft.ID;	
        var end:Number = edges[e].Tright.ID;                
        
        // Create a weight for this edge.
        // Compute dualvertex-to-dualvertex length.        
        var cx1:Number = dual_nodes_x[start]; // (triangles[start].A.rx + triangles[start].B.rx + triangles[start].C.rx)/3.0;
        var cy1:Number = dual_nodes_y[start]; // (triangles[start].A.ry + triangles[start].B.ry + triangles[start].C.ry)/3.0;      
        var cx2:Number = dual_nodes_x[end];   // (triangles[end].A.rx + triangles[end].B.rx + triangles[end].C.rx)/3.0;
        var cy2:Number = dual_nodes_y[end];   // (triangles[end].A.ry + triangles[end].B.ry + triangles[end].C.ry)/3.0;
        var c2c_dist:Number = Math.sqrt( (cx1-cx2)*(cx1-cx2) + (cy1-cy2)*(cy1-cy2) );
              
        // Compute effective width multiplier.         
        var dx:Number = edges[e].B1.rx - edges[e].B2.rx;
        var dy:Number = edges[e].B1.ry - edges[e].B2.ry;        
        var total_length:Number = Math.sqrt (dx*dx+dy*dy);        
        var width_factor:Number = total_length / (total_length - edges[e].B1.collision_radius - edges[e].B2.collision_radius+1);
        
        // Compute triangle shape multiplier - if either dualvertex is off the screen, scale up a penalty.
        var shape_factor:Number = 1.0;                        
        if (cx1 > 800)
          shape_factor += 0.3;
        if (cx1 < 0)
          shape_factor += 0.3;
        if (cx2 > 800)
          shape_factor += 0.3;
        if (cx2 < 0)
          shape_factor += 0.3;           
        if (cy1 > 600)
          shape_factor += 0.3;
        if (cy1 < 0)
          shape_factor += 0.3;
        if (cy2 > 600)
          shape_factor += 0.3;
        if (cy2 < 0)
          shape_factor += 0.3;   
          
        
        // Compute collapse multiplier - shrinking edges are labeled with larger weight, while growing edges are labeled with smaller weight.
        // Normalize edge length.
        dx /= total_length;
        dy /= total_length;
        
        // Dot velocity against edge vector.
        var dot1 : Number = -(edges[e].B1.vx*dx + edges[e].B1.vy * dy);
        var dot2 : Number = edges[e].B2.vx * dx + edges[e].B2.vy * dy;
        // Positive dot indicates a shrinking edge.
        // dot1 and dot2 are measured in "pixels shrunk per frame"
        // Compute how much shrinking will occur in 10 frames. If the
        var shrunksize:Number = Math.max (0.1 * total_length, total_length - (dot1+dot2)*10.0 );
        var collapse_factor:Number = total_length / shrunksize;  
        // If an edge shrinks very small, this term grows very large and the edge gets large weight.
        // This term can never be larger than 10, because shrunksize cannot be smaller that 0.1*total_length. 
        
        
        var weight:Number = c2c_dist*width_factor*shape_factor*collapse_factor;        
        
        // Create a new edge.
        var newedge1:GraphEdge = new GraphEdge;
        newedge1.start = start;
        newedge1.end = end;        
        newedge1.weight = weight;
        
               
        
        // Create the reverse edge too.
        var newedge2:GraphEdge = new GraphEdge;
        newedge2.start = end;
        newedge2.end = start;        
        newedge2.weight = weight;
        
        // Add to graph.        
        graph[start].push(newedge1);
        graph[end].push(newedge2);
        }      
    }
 
  public function drawDualGraph(_root:Sprite) : void
    {
    for (var t1:Number=0; t1 < graph.length; t1++)
      for (var t2:Number= 0; t2 < graph[t1].length; t2++)
        {        
        var cx_start:Number = (triangles[ graph[t1][t2].start ].A.rx + triangles[ graph[t1][t2].start ].B.rx + triangles[ graph[t1][t2].start ].C.rx)/3.0;
        var cy_start:Number = (triangles[ graph[t1][t2].start ].A.ry + triangles[ graph[t1][t2].start ].B.ry + triangles[ graph[t1][t2].start ].C.ry)/3.0;
        
        var cx_end:Number = (triangles[ graph[t1][t2].end ].A.rx + triangles[ graph[t1][t2].end ].B.rx + triangles[ graph[t1][t2].end ].C.rx)/3.0;
        var cy_end:Number = (triangles[ graph[t1][t2].end ].A.ry + triangles[ graph[t1][t2].end ].B.ry + triangles[ graph[t1][t2].end ].C.ry)/3.0;
       
       
        cx_start = dual_nodes_x[ graph[t1][t2].start ];
        cy_start = dual_nodes_y[ graph[t1][t2].start ];
       
        cx_end = dual_nodes_x[ graph[t1][t2].end ];
        cy_end = dual_nodes_y[ graph[t1][t2].end ];
       
        // Sketch line. 	
        _root.graphics.lineStyle(2, 0xE00000, 1);	
        _root.graphics.moveTo(cx_start,cy_start);
        _root.graphics.lineTo(cx_end, cy_end);
        }
      
    }
  
  
  public function shortestPath (p1:Particle, p2:Particle, _root : Sprite) : Number
    // Compute shortest path on the dual grid from p1 to p2 using dijkstras algorithm.
    {
    	
    // Find particle p1.
    var source:Number = whereIs(p1).ID;
    var dest:Number = whereIs(p2).ID;
    
    var n:Number;
    var e:Number;
    var minIndex:Number;
    
    // Initialize costList - all vertices except for the source are undiscovered and have infinite cost. Represent this with sentinel value -1.
    var costList:Array = new Array;
    var previous:Array = new Array;
    var visited_marks:Array = new Array;
    
    for (n=0; n < triangles.length; n++)
      {
      costList[n] = -1;
      previous[n] = -1;
      visited_marks[n] = false;
      }
    costList[source] = 0;
                        
    // Keep going until the destination node is found. 
    var visited:Number = 0;    
    
    while (visited < triangles.length)
      {
      // Select minimum cost vertex outside the cloud.
      minIndex = -1;
      for (n = 0; n < triangles.length; n++)        
        // Is this an undiscovered vertex?
        if (!visited_marks[n])
          {
          if (costList[n] != -1)	
            {
            if (minIndex == -1)
              minIndex = n;                       
            else  
              if (costList[n] < costList[minIndex])
                minIndex = n;
            }
          }
      // minIndex now holds the vertex with minimum cost to visit. 	
      
      //cout.text = cout.text + "V" + minIndex + " ";      
      visited_marks[minIndex] = true;
      visited++;
      /*
      var cx_end:Number = (triangles[ minIndex ].A.rx + triangles[ minIndex ].B.rx + triangles[ minIndex ].C.rx)/3.0;
      var cy_end:Number = (triangles[ minIndex ].A.ry + triangles[ minIndex ].B.ry + triangles[ minIndex ].C.ry)/3.0;
      _root.graphics.lineStyle(5, 0xE0E000, 1);	
      _root.graphics.moveTo(0, 0);
      _root.graphics.lineTo(cx_end, cy_end);      
      */  
        
      
      // Relax vertices incident upon minIndex.
      for (e = 0; e < graph[minIndex].length; e++)       
        {
        var v : Number = graph[minIndex][e].end;        
        var u : Number = graph[minIndex][e].start;	        
        
        // Is this an edge out of the cloud of visited vertices?
        if (!visited_marks[v])
          {
         
          if (costList[v] == -1)
            // Have we discovered a path to an "infinity" node?	
            {
            costList[v] = costList[u] + graph[u][e].weight;
            previous[v] = u;            
            }
          else	          
            if (costList[u] + graph[u][e].weight < costList[ v ] )
            // Can the endnode of this edge be reached more cheaply?
              {
              costList[v] = costList[u] + graph[u][e].weight;
              previous[v] = u;          
              }
          }
        }         
      }
            
    // Sketch the path.  
    /*
    _root.graphics.lineStyle(5, 0x00E000, 1);	
    var currentPos2:Number = dest;
    var cx:Number = dual_nodes_x[currentPos2];
    var cy:Number = dual_nodes_y[currentPos2];        
    _root.graphics.moveTo(cx,cy);    
    
    while(currentPos2 != source)    
      {
      currentPos2 = previous[currentPos2];      
      if (currentPos2 != -1)
        {
        cx = dual_nodes_x[currentPos2];
        cy = dual_nodes_y[currentPos2];        
        _root.graphics.lineTo(cx, cy);
        }
      }    
    */
    
    // Compute 
    // Which edge of source triangle should we return? Look for the "2nd" triangle.        
    var currentPos:Number = dest;
    while(previous[currentPos] != source)          
      currentPos = previous[currentPos];    
    
    
    var second:Number = currentPos;            
    // Look for the graph edge which is from source to second.
    // Search edgeAB
    if (triangles[source].edgeAB.Tleft == triangles[source])
      if (triangles[source].edgeAB.Tright == triangles[second])
        return 0;    
    if (triangles[source].edgeAB.Tright == triangles[source])
       if (triangles[source].edgeAB.Tleft == triangles[second])
         return 0;
    // Search edgeBC
    if (triangles[source].edgeBC.Tleft == triangles[source])
      if (triangles[source].edgeBC.Tright == triangles[second])
        return 1;    
    if (triangles[source].edgeBC.Tright == triangles[source])
       if (triangles[source].edgeBC.Tleft == triangles[second])
         return 1;
    // Search edgeCA
    if (triangles[source].edgeCA.Tleft == triangles[source])
      if (triangles[source].edgeCA.Tright == triangles[second])
        return 2;    
    if (triangles[source].edgeCA.Tright == triangles[source])
       if (triangles[source].edgeCA.Tleft == triangles[second])
         return 2;
        
    _root.graphics.moveTo(0, 600);
    _root.graphics.lineTo(800, 0);
    return -1;       
    
    }
  
  
  public function whereIs (x:Particle) : Triangle
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
  
  public function insert(x:Body) : void
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
    var returnValue:Boolean = false;	
    for (var t:Number = 0; t < triangles.length; t++)	
      {
      triangles[t].computeAngles();		    
      triangles[t].ID = t;            
      }
    return returnValue;  
    }
    
  public function draw(_root:Sprite)  : void
    {    
    
    _root.graphics.lineStyle(2, 0x006400, 100);	  
    
    for (var t:Number = 0; t < triangles.length; t++)
      {    
      var alpha:Number = 1.0;
      var cx:Number = (triangles[t].A.rx + triangles[t].B.rx + triangles[t].C.rx)/3.0;
      var cy:Number = (triangles[t].A.ry + triangles[t].B.ry + triangles[t].C.ry)/3.0;      
      _root.graphics.moveTo(alpha * triangles[t].A.rx + (1-alpha) * cx, alpha * triangles[t].A.ry + (1-alpha) * cy );
      _root.graphics.lineTo(alpha * triangles[t].B.rx + (1-alpha) * cx, alpha * triangles[t].B.ry + (1-alpha) * cy );
      _root.graphics.lineTo(alpha * triangles[t].C.rx + (1-alpha) * cx, alpha * triangles[t].C.ry + (1-alpha) * cy );
      _root.graphics.lineTo(alpha * triangles[t].A.rx + (1-alpha) * cx, alpha * triangles[t].A.ry + (1-alpha) * cy );            
      }
    
    /*  
    for (var e:Number = 0; e < edges.length; e++)
      {     
      _root.moveTo(edges[e].B1.rx,edges[e].B1.ry);	
      _root.lineTo(edges[e].B2.rx,edges[e].B2.ry);	        
    
      var cx:Number = (edges[e].B1.rx+edges[e].B2.rx)/2.0;
      var cy:Number = (edges[e].B1.ry+edges[e].B2.ry)/2.0;
      var junk:MovieClip = _root.createEmptyMovieClip (""+_root.getNextHighestDepth(),_root.getNextHighestDepth());
      junk.createTextField("thetext",1, cx, cy, 25, 25);      
      junk.thetext.text = ""+e;
    
      }    
    */          
    }
  
  public function cleanUp () : void
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
   
    edges[e].Tleft.computeAngles();
    edges[e].Tright.computeAngles();
   
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
      
      var existingQuality:Number = Math.min (edges[e].Tleft.minAngle, edges[e].Tright.minAngle);
      var newQuality:Number = Math.min (t1new.minAngle, t2new.minAngle);      

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
        
        var oldTleft:Number = edges[e].Tleft.ID;
        var oldTright:Number = edges[e].Tright.ID;        
        
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
  
} // end package