void Dijkstra() {
  if (route.size() > 0) {
    int winner = 0;
    for (int i = 0; i < route.size(); i++) {
      if (route.get(i).dist < route.get(winner).dist) {
        winner = i;
      }
    }
    current = route.get(winner);
    current.visited = true;
    if (current == end) {
      findPath = true;
      //noLoop();
      drawWindow();
      return;
    }
    route.remove(winner);

    ArrayList<Cell> neighbours = current.neighbours;
    for (Cell neighbour : neighbours) {
      if (!neighbour.visited) {
        int alt = current.dist + 1;
        if (alt < neighbour.dist) {
          neighbour.dist = alt;
          neighbour.previous = current;
        }
      }
    }
  } else {
    println("no solution");
    noLoop();
    return;
  }
  drawWindow();
}

void drawWindow() {
  background(20);
  for (Cell c : grid) {
    if (current == c && !findPath)
      c.show(color(0, 255, 0, 150));
    else if (!c.visited || findPath)
      c.show(color(50, 100));
    else 
    c.show(color(200, 0, 0, 150));
  }
  end.show(color(200, 0, 150));
  
  ArrayList<Cell> path = new ArrayList<Cell>();
  Cell temp = current;
  path.add(temp);
  while (temp.previous != null) {
    path.add(temp.previous);
    temp = temp.previous;
  }

  if (findPath) {
    boolean endTrack = false;
    
    stroke(200, 0, 150);
    strokeWeight(w / 2);
    Cell track = current.previous;
    line(current.i * w + w / 2, current.j * w + w / 2, 
      track.i * w + w / 2, track.j * w + w / 2);
    for (int n = 0; n < pathCount; n++) {
      if (track.previous != null) {
        line(track.i * w + w / 2, track.j * w + w / 2, 
          track.previous.i * w + w / 2, track.previous.j * w + w / 2);
        track = track.previous;
      } else {
        endTrack = true;
      }
    }
    pathCount++;
    strokeWeight(2);
    
    if (endTrack) {
      delay(3000);
      reset();
    }
    return;
  }

  noFill();
  stroke(255, 255, 0, 200);
  strokeWeight(w / 2);
  beginShape();
  for (int i = 0; i < path.size(); i++) {
    vertex(path.get(i).i * w + w / 2, path.get(i).j * w + w / 2);
  }
  endShape();
  strokeWeight(2);
}
