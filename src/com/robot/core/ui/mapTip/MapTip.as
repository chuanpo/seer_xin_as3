package com.robot.core.ui.mapTip
{
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UIManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import org.taomee.utils.DisplayUtil;
   
   public class MapTip
   {
      private static var bgMC:MovieClip;
      
      private static var _info:MapTipInfo;
      
      private static var tipMC:Sprite;
      
      private static var itemContainer:Sprite;
      
      private static var leftGap:Number = 5;
      
      private static var rightGap:Number = 5;
      
      public function MapTip()
      {
         super();
      }
      
      public static function show(info:MapTipInfo, container:DisplayObjectContainer = null) : void
      {
         var h:Number = NaN;
         var lastItem:MapTipItem = null;
         var count:uint = 0;
         var type:uint = 0;
         var item:MapTipItem = null;
         var i:MapItemTipInfo = null;
         tipMC = getTipMC();
         itemContainer = new Sprite();
         bgMC = UIManager.getMovieClip("MapTipBg");
         tipMC.addChild(bgMC);
         tipMC.addChild(itemContainer);
         if(Boolean(info))
         {
            h = 0;
            count = 0;
            for each(type in info.contentList)
            {
               item = new MapTipItem();
               i = new MapItemTipInfo(info.id,type);
               item.info = i;
               if(Boolean(lastItem))
               {
                  item.y = h + lastItem.height + 2;
               }
               itemContainer.addChild(item);
               lastItem = item;
               h = item.y;
               count++;
            }
            bgMC.width = itemContainer.width + leftGap * 2;
            bgMC.height = itemContainer.height + rightGap * 2;
            itemContainer.x = leftGap;
            itemContainer.y = rightGap;
         }
         if(Boolean(container))
         {
            container.addChild(tipMC);
         }
         else
         {
            LevelManager.appLevel.addChild(tipMC);
         }
         tipMC.x = -200;
         tipMC.y = -500;
         tipMC.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
      }
      
      public static function hide() : void
      {
         if(Boolean(tipMC))
         {
            tipMC.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
            DisplayUtil.removeAllChild(tipMC);
            DisplayUtil.removeForParent(tipMC);
         }
      }
      
      private static function enterFrameHandler(event:Event) : void
      {
         if(tipMC == null)
         {
            return;
         }
         if(MainManager.getStage().mouseX + tipMC.width + 20 >= MainManager.getStageWidth())
         {
            tipMC.x = MainManager.getStageWidth() - tipMC.width - 10;
         }
         else
         {
            tipMC.x = MainManager.getStage().mouseX + 10;
         }
         if(MainManager.getStage().mouseY + tipMC.height + 20 >= MainManager.getStageHeight())
         {
            tipMC.y = MainManager.getStageHeight() - tipMC.height - 10;
         }
         else
         {
            tipMC.y = MainManager.getStage().mouseY - tipMC.height / 2;
         }
      }
      
      private static function getTipMC() : Sprite
      {
         if(tipMC == null)
         {
            tipMC = new Sprite();
         }
         return tipMC;
      }
   }
}

