package com.robot.app.freshFightLevel
{
   import com.robot.core.CommandID;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.net.SocketConnection;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.ApplicationDomain;
   import org.taomee.utils.DisplayUtil;
   
   public class FightListPanel
   {
      private static var app:ApplicationDomain;
      
      private static var panel:Sprite;
      
      private static var infoA:Array;
      
      private static var addEventA:Array;
      
      private static var b1:Boolean = false;
      
      private static const defaultLength:uint = 3;
      
      private static const dedaultPoint:Point = new Point(84.5,24.6);
      
      private static const rec:Rectangle = new Rectangle(dedaultPoint.x,dedaultPoint.y,0,107);
      
      private static const move:uint = 3;
      
      public function FightListPanel()
      {
         super();
      }
      
      public static function show(cc:DisplayObjectContainer, p:Point, app:ApplicationDomain, a:Array) : void
      {
         if(!panel)
         {
            panel = new (app.getDefinition("UI_ListPanel") as Class)() as Sprite;
         }
         infoA = a;
         addEventA = new Array();
         addItem(app);
         for(var i1:int = 0; i1 < defaultLength; i1++)
         {
            panel.getChildByName("item" + i1)["txt"].text = String(infoA[i1].itemId);
            if(infoA[i1].isOpen == true)
            {
               panel.getChildByName("item" + i1)["maskMc"].visible = false;
               (panel.getChildByName("item" + i1) as MovieClip).buttonMode = true;
               panel.getChildByName("item" + i1).addEventListener(MouseEvent.CLICK,onClickHandler);
               addEventA.push(i1);
            }
         }
         panel.alpha = 0;
         cc.addChild(panel);
         panel.x = p.x;
         panel.y = p.y;
         panel.addEventListener(Event.ENTER_FRAME,onEnterHandler);
         b1 = true;
      }
      
      private static function addItem(app:ApplicationDomain) : void
      {
         var item:Sprite = null;
         for(var i1:int = 0; i1 < defaultLength; i1++)
         {
            item = new (app.getDefinition("UI_Item") as Class)() as Sprite;
            item.x = 25;
            item.y = 17 + (item.height + 13) * i1;
            item.name = "item" + i1;
            panel.addChild(item);
         }
      }
      
      private static function addDataToItem(a:Array) : void
      {
      }
      
      private static function onEnterHandler(e:Event) : void
      {
         if(panel.alpha < 1)
         {
            panel.alpha += 0.2;
         }
         else
         {
            panel.removeEventListener(Event.ENTER_FRAME,onEnterHandler);
            b1 = false;
         }
      }
      
      private static function onClickHandler(e:MouseEvent) : void
      {
         var nameStr:String = (e.currentTarget as MovieClip)["txt"].text;
         var id:uint = uint(nameStr.slice(0,1));
         if(nameStr.length == 1)
         {
            id = uint(nameStr);
         }
         else
         {
            id = uint(uint(nameStr.slice(0,1)) + 1);
         }
         choice(id);
      }
      
      private static function choice(id:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.FRESH_CHOICE_FIGHT_LEVEL,onChoiceSuccessHandler);
         SocketConnection.send(CommandID.FRESH_CHOICE_FIGHT_LEVEL,id);
      }
      
      private static function onChoiceSuccessHandler(e:*) : void
      {
         SocketConnection.removeCmdListener(CommandID.FRESH_CHOICE_FIGHT_LEVEL,onChoiceSuccessHandler);
         var bossId:FreshChoiceLevelRequestInfo = e.data as FreshChoiceLevelRequestInfo;
         FightLevelModel.setBossId = bossId.getBossId;
         FightLevelModel.setCurLevel = bossId.getLevel;
         MainManager.actorInfo.curFreshStage = bossId.getLevel;
         FightChoiceController.hide();
         MapManager.changeMap(600);
      }
      
      public static function destroy() : void
      {
         var i1:int = 0;
         if(Boolean(addEventA))
         {
            if(addEventA.length > 0)
            {
               for(i1 = 0; i1 < addEventA.length; i1++)
               {
                  panel.getChildByName("item" + addEventA[i1]).removeEventListener(MouseEvent.CLICK,onClickHandler);
               }
            }
         }
         if(b1)
         {
            panel.removeEventListener(Event.ENTER_FRAME,onEnterHandler);
         }
         DisplayUtil.removeForParent(panel);
         panel = null;
         infoA = null;
         app = null;
         addEventA = null;
      }
   }
}

