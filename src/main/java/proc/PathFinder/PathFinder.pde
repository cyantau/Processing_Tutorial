int cols, rows;
int w = 20;
Cell[] grid;
Cell start;
Cell end;
boolean drawFinish = false;
boolean findPath = false;
int pathCount = 0;
int methodCount = 0;

Cell current;
ArrayList<Cell> stack;

// A*
ArrayList<Cell> openSet;
ArrayList<Cell> closedSet;

// Best First
ArrayList<Cell> route;


int heuristic(Cell a, Cell b) {
  return abs(a.i - b.i) + abs(a.j - b.j);
}

void setup() {
  size(1000, 1000);
  cols = (int)(width / w);
  rows = (int)(height / w);
  grid = new Cell[cols * rows];
  
  stack = new ArrayList<Cell>();

  for (int j = 0; j < rows; j++) {
    for (int i = 0; i < cols; i++) {
      grid[i + j * rows] = new Cell(i, j);
    }
  }
  current = grid[0];
  start = grid[0];
  end = grid[grid.length - 1];

  openSet = new ArrayList<Cell>();
  closedSet = new ArrayList<Cell>();
  openSet.add(start);

  route = new ArrayList<Cell>();
  route.add(start);
}

void draw() {
  background(20);
  strokeWeight(2);
  if (!drawFinish) {
    for (int i = 0; i < grid.length; i++) {
      grid[i].show(color(50, 100));
    }
    for (int i = 0; i < 10; i++) {
      current.visited = true;
      current.highlight();
      Cell next = current.checkNeighbours();
      if (next != null) {
        next.visited = true;
        stack.add(current);

        removeWalls(current, next);

        current = next;
      } else if (stack.size() > 0) {
        current = stack.remove(stack.size() - 1);
      }
      if (frameCount > 10 && stack.size() == 0) {
        drawFinish = true;
        for (Cell c : grid) {
          c.addNeighbours();
          c.visited = false;
        }
        start.visited = true;
        return;
      }
    }
  } else {
    if (methodCount == 0)
      AStar();
    else if (methodCount == 1)
      GreedyFirst();
    else if (methodCount == 2)
      BFS();
    else if (methodCount == 3)
      DFS();
    else if (methodCount == 4)
      Dijkstra();
    else
      noLoop();
    return;
  }
}

void removeWalls(Cell a, Cell b) {
  int x = a.i - b.i;
  if (x == 1) {
    a.walls[3] = false;
    b.walls[1] = false;
  } else if (x == -1) {
    a.walls[1] = false;
    b.walls[3] = false;
  } 
  int y = a.j - b.j;
  if (y == 1) {
    a.walls[0] = false;
    b.walls[2] = false;
  } else if (y == -1) {
    a.walls[2] = false;
    b.walls[0] = false;
  }
}

void reset() {
  findPath = false;
  pathCount = 0;
  methodCount++;
  methodCount = methodCount % 5;
  println(methodCount);

  current = grid[0];
  start = grid[0];
  end = grid[grid.length - 1];

  openSet = new ArrayList<Cell>();
  closedSet = new ArrayList<Cell>();
  route = new ArrayList<Cell>();
  openSet.add(start);
  route.add(start);

  if (methodCount == 4) {
    for (Cell c : grid) {
      c.visited = false;
      route.add(c);
    }
    route.get(0).dist = 0;
    return;
  }

  for (Cell c : grid) {
    c.visited = false;
  }
  start.visited = true;
}
