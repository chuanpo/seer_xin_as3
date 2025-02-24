package com.robot.core.aimat
{
   import com.robot.core.event.ItemEvent;
   import com.robot.core.manager.ItemManager;
   import com.robot.core.manager.UIManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import org.taomee.manager.PopUpManager;
   import org.taomee.utils.DisplayUtil;
   
   public class AimatGridPanel
   {
      private static var bgMC:MovieClip;
      
      private static var gridArray:Array = [];
      
      setup();
      
      public function AimatGridPanel()
      {
         super();
      }
      
      private static function setup() : void
      {
         var grid:AimatGrid = null;
         var i:uint = 0;
         bgMC = UIManager.getMovieClip("ui_ThrowThingPanel");
         grid = new AimatGrid();
         grid.x = 6;
         grid.y = 4;
         bgMC.addChild(grid);
         grid.itemID = 0;
         grid.addEventListener(AimatGrid.CLICK,onGridClick);
         for(i = 1; i < 9; i++)
         {
            grid = new AimatGrid();
            grid.x = 6 + (grid.width + 3) * (i % 3);
            grid.y = 4 + (grid.height + 3) * Math.floor(i / 3);
            bgMC.addChild(grid);
            gridArray.push(grid);
            grid.addEventListener(AimatGrid.CLICK,onGridClick);
         }
         ItemManager.addEventListener(ItemEvent.THROW_LIST,onThrowList);
      }
      
      public static function show(btn:DisplayObject) : void
      {
         if(DisplayUtil.hasParent(bgMC))
         {
            hide();
            return;
         }
         clear();
         PopUpManager.showForDisplayObject(bgMC,btn,PopUpManager.TOP_LEFT,true,new Point((bgMC.width + btn.width) / 2,0));
         ItemManager.getThrowThing();
      }
      
      public static function hide() : void
      {
         DisplayUtil.removeForParent(bgMC,false);
      }
      
      private static function onThrowList(event:Event) : void
      {
         var i:uint = 0;
         var grid:AimatGrid = null;
         var ids:Array = ItemManager.getThrowIDs();
         var count:uint = 0;
         for each(i in ids)
         {
            grid = gridArray[count];
            grid.itemID = i;
            count++;
         }
      }
      
      private static function clear() : void
      {
         var i:AimatGrid = null;
         for each(i in gridArray)
         {
            i.empty();
         }
      }
      
      private static function onGridClick(event:Event) : void
      {
         hide();
      }
   }
}

