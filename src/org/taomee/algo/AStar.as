package org.taomee.algo
{
   import flash.geom.Point;
   
   public class AStar
   {
      private static var _instance:AStar;
      
      public static const aroundsData:Array = [new Point(1,0),new Point(0,1),new Point(-1,0),new Point(0,-1),new Point(1,1),new Point(-1,1),new Point(-1,-1),new Point(1,-1)];
      
      private var _fatherList:Array;
      
      private const NOTE_ID:int = 0;
      
      private var _noteMap:Array;
      
      private var _mapModel:IMapModel;
      
      private var _maxTry:int;
      
      private const NOTE_CLOSED:int = 2;
      
      private var _nodeList:Array;
      
      private var _openId:int;
      
      private var _openCount:int;
      
      private const COST_DIAGONAL:int = 14;
      
      private var _pathScoreList:Array;
      
      private var _openList:Array;
      
      private const COST_STRAIGHT:int = 10;
      
      private const NOTE_OPEN:int = 1;
      
      private var _movementCostList:Array;
      
      public function AStar()
      {
         super();
      }
      
      public static function find(p_start:Point, p_end:Point) : Array
      {
         return getInstance()._find(p_start,p_end);
      }
      
      private static function getInstance() : AStar
      {
         if(_instance == null)
         {
            _instance = new AStar();
         }
         return _instance;
      }
      
      public static function get maxTry() : int
      {
         return getInstance()._maxTry;
      }
      
      public static function init(mapModel:IMapModel, maxTry:int = 1000) : void
      {
         getInstance()._mapModel = mapModel;
         getInstance()._maxTry = maxTry;
      }
      
      private function isBlock(p:Point) : Boolean
      {
         if(p.x < 0 || p.x >= _mapModel.gridX || p.y < 0 || p.y >= _mapModel.gridY)
         {
            return false;
         }
         return _mapModel.data[p.x][p.y];
      }
      
      private function _find(p_start:Point, p_end:Point) : Array
      {
         var currId:int = 0;
         var currNoteP:Point = null;
         var checkingId:int = 0;
         var cost:int = 0;
         var score:int = 0;
         var aroundNotes:Array = null;
         var note:Point = null;
         if(_mapModel == null)
         {
            return null;
         }
         p_start = transPoint(p_start);
         var endPos:Point = transPoint(p_end.clone());
         if(!isBlock(endPos))
         {
            return null;
         }
         initLists();
         _openCount = 0;
         _openId = -1;
         openNote(p_start,0,0,0);
         var currTry:int = 0;
         while(_openCount > 0)
         {
            if(++currTry > _maxTry)
            {
               destroyLists();
               return null;
            }
            currId = int(_openList[0]);
            closeNote(currId);
            currNoteP = _nodeList[currId];
            if(endPos.equals(currNoteP))
            {
               return getPath(p_start,currId);
            }
            aroundNotes = getArounds(currNoteP);
            for each(note in aroundNotes)
            {
               cost = _movementCostList[currId] + (note.x == currNoteP.x || note.y == currNoteP.y ? COST_STRAIGHT : COST_DIAGONAL);
               score = cost + (Math.abs(endPos.x - note.x) + Math.abs(endPos.y - note.y)) * COST_STRAIGHT;
               if(isOpen(note))
               {
                  checkingId = int(_noteMap[note.y][note.x][NOTE_ID]);
                  if(cost < _movementCostList[checkingId])
                  {
                     _movementCostList[checkingId] = cost;
                     _pathScoreList[checkingId] = score;
                     _fatherList[checkingId] = currId;
                     aheadNote(_openList.indexOf(checkingId) + 1);
                  }
               }
               else
               {
                  openNote(note,score,cost,currId);
               }
            }
         }
         destroyLists();
         return null;
      }
      
      private function closeNote(p_id:int) : void
      {
         --_openCount;
         var noteP:Point = _nodeList[p_id];
         _noteMap[noteP.y][noteP.x][NOTE_OPEN] = false;
         _noteMap[noteP.y][noteP.x][NOTE_CLOSED] = true;
         if(_openCount <= 0)
         {
            _openCount = 0;
            _openList = [];
            return;
         }
         _openList[0] = _openList.pop();
         backNote();
      }
      
      private function isOpen(p:Point) : Boolean
      {
         if(_noteMap[p.y] == null)
         {
            return false;
         }
         if(_noteMap[p.y][p.x] == null)
         {
            return false;
         }
         return _noteMap[p.y][p.x][NOTE_OPEN];
      }
      
      private function getArounds(p:Point) : Array
      {
         var checkP:Point = null;
         var canDiagonal:Boolean = false;
         var arr:Array = [];
         var i:int = 0;
         checkP = p.add(aroundsData[i]);
         i++;
         var canRight:Boolean = isBlock(checkP);
         if(canRight && !isClosed(checkP))
         {
            arr.push(checkP);
         }
         checkP = p.add(aroundsData[i]);
         i++;
         var canDown:Boolean = isBlock(checkP);
         if(canDown && !isClosed(checkP))
         {
            arr.push(checkP);
         }
         checkP = p.add(aroundsData[i]);
         i++;
         var canLeft:Boolean = isBlock(checkP);
         if(canLeft && !isClosed(checkP))
         {
            arr.push(checkP);
         }
         checkP = p.add(aroundsData[i]);
         i++;
         var canUp:Boolean = isBlock(checkP);
         if(canUp && !isClosed(checkP))
         {
            arr.push(checkP);
         }
         checkP = p.add(aroundsData[i]);
         i++;
         canDiagonal = isBlock(checkP);
         if(canDiagonal && canRight && canDown && !isClosed(checkP))
         {
            arr.push(checkP);
         }
         checkP = p.add(aroundsData[i]);
         i++;
         canDiagonal = isBlock(checkP);
         if(canDiagonal && canLeft && canDown && !isClosed(checkP))
         {
            arr.push(checkP);
         }
         checkP = p.add(aroundsData[i]);
         i++;
         canDiagonal = isBlock(checkP);
         if(canDiagonal && canLeft && canUp && !isClosed(checkP))
         {
            arr.push(checkP);
         }
         checkP = p.add(aroundsData[i]);
         i++;
         canDiagonal = isBlock(checkP);
         if(canDiagonal && canRight && canUp && !isClosed(checkP))
         {
            arr.push(checkP);
         }
         return arr;
      }
      
      private function aheadNote(p_index:int) : void
      {
         var father:int = 0;
         var change:int = 0;
         while(p_index > 1)
         {
            father = int(p_index / 2);
            if(getScore(p_index) >= getScore(father))
            {
               break;
            }
            change = int(_openList[p_index - 1]);
            _openList[p_index - 1] = _openList[father - 1];
            _openList[father - 1] = change;
            p_index = father;
         }
      }
      
      private function backNote() : void
      {
         var tmp:int = 0;
         var change:int = 0;
         var checkIndex:int = 1;
         while(true)
         {
            tmp = checkIndex;
            if(2 * tmp <= _openCount)
            {
               if(getScore(checkIndex) > getScore(2 * tmp))
               {
                  checkIndex = 2 * tmp;
               }
               if(2 * tmp + 1 <= _openCount)
               {
                  if(getScore(checkIndex) > getScore(2 * tmp + 1))
                  {
                     checkIndex = 2 * tmp + 1;
                  }
               }
            }
            if(tmp == checkIndex)
            {
               break;
            }
            change = int(_openList[tmp - 1]);
            _openList[tmp - 1] = _openList[checkIndex - 1];
            _openList[checkIndex - 1] = change;
         }
      }
      
      private function openNote(p:Point, p_score:int, p_cost:int, p_fatherId:int) : void
      {
         ++_openCount;
         ++_openId;
         if(_noteMap[p.y] == null)
         {
            _noteMap[p.y] = [];
         }
         _noteMap[p.y][p.x] = [];
         _noteMap[p.y][p.x][NOTE_OPEN] = true;
         _noteMap[p.y][p.x][NOTE_ID] = _openId;
         _nodeList.push(p);
         _pathScoreList.push(p_score);
         _movementCostList.push(p_cost);
         _fatherList.push(p_fatherId);
         _openList.push(_openId);
         aheadNote(_openCount);
      }
      
      private function eachArray(element:Point, index:int, arr:Array) : void
      {
         element.x *= _mapModel.gridSize;
         element.y *= _mapModel.gridSize;
      }
      
      private function transPoint(p:Point) : Point
      {
         p.x = int(p.x / _mapModel.gridSize);
         p.y = int(p.y / _mapModel.gridSize);
         return p;
      }
      
      private function getPath(p_start:Point, p_id:int) : Array
      {
         var arr:Array = [];
         var noteP:Point = _nodeList[p_id];
         while(!p_start.equals(noteP))
         {
            arr.push(noteP);
            p_id = int(_fatherList[p_id]);
            noteP = _nodeList[p_id];
         }
         arr.push(p_start);
         destroyLists();
         arr.reverse();
         optimize(arr);
         arr.forEach(eachArray);
         return arr;
      }
      
      private function getScore(p_index:int) : int
      {
         return _pathScoreList[_openList[p_index - 1]];
      }
      
      private function initLists() : void
      {
         _openList = [];
         _nodeList = [];
         _pathScoreList = [];
         _movementCostList = [];
         _fatherList = [];
         _noteMap = [];
      }
      
      private function destroyLists() : void
      {
         _openList = null;
         _nodeList = null;
         _pathScoreList = null;
         _movementCostList = null;
         _fatherList = null;
         _noteMap = null;
      }
      
      private function isClosed(p:Point) : Boolean
      {
         if(_noteMap[p.y] == null)
         {
            return false;
         }
         if(_noteMap[p.y][p.x] == null)
         {
            return false;
         }
         return _noteMap[p.y][p.x][NOTE_CLOSED];
      }
      
      private function optimize(arr:Array, index:int = 0) : void
      {
         var p2:Point = null;
         var dis:int = 0;
         var angle:Number = NaN;
         var c:int = 0;
         var w:int = 0;
         var checkP:Point = null;
         if(arr == null)
         {
            return;
         }
         var _nLen:int = arr.length - 1;
         if(_nLen < 2)
         {
            return;
         }
         var p1:Point = arr[index];
         var newArr:Array = [];
         for(var i:int = _nLen; i > index; i--)
         {
            p2 = arr[i];
            dis = Point.distance(p1,p2);
            angle = Math.atan2(p2.y - p1.y,p2.x - p1.x);
            for(c = 1; c < dis; c++)
            {
               checkP = p1.add(Point.polar(c,angle));
               checkP.x = int(checkP.x);
               checkP.y = int(checkP.y);
               if(!Boolean(_mapModel.data[checkP.x][checkP.y]))
               {
                  newArr = [];
                  break;
               }
               newArr.push(checkP);
            }
            w = int(newArr.length);
            if(w > 0)
            {
               arr.splice(index + 1,i - index - 1);
               index += w - 1;
               break;
            }
         }
         if(index < _nLen)
         {
            optimize(arr,++index);
         }
      }
   }
}

