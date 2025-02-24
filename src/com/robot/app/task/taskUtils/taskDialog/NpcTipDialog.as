package com.robot.app.task.taskUtils.taskDialog
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UIManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   public class NpcTipDialog
   {
      private static var oldStr:String;
      
      public static const HELPMACH:String = "helpmach";
      
      public static const GUARD:String = "guard";
      
      public static const BAD_GUARD:String = "badguy";
      
      public static const SHU_KE:String = "suke";
      
      public static const SEER_SAD:String = "seer_2";
      
      public static const SEER:String = "seer_1";
      
      public static const ZISESEER:String = "ziseSeer";
      
      public static const CICI:String = "xixi";
      
      public static const IRIS:String = "iris";
      
      public static const INSTRUCTOR:String = "instructor";
      
      public static const JUSTIN:String = "justin";
      
      public static const SHIPER:String = "shiper";
      
      public static const DOCTOR:String = "doctor";
      
      public static const ALLISON:String = "allison";
      
      public static const QILUO:String = "qiluo";
      
      public static const DINGDING:String = "dingding";
      
      public static const DONGDONG:String = "dongdong";
      
      public static const MARK:String = "mark";
      
      public static const XITA:String = "xita";
      
      public static const XUAN_BING_SHOU_1:String = "xuanbingshou_1";
      
      public static const XUAN_BING_SHOU_2:String = "xuanbingshou_2";
      
      public static const XUAN_BING_SHOU_3:String = "xuanbingshou_3";
      
      public static const MAOMAO_1:String = "maomao_1";
      
      public static const MAOMAO_2:String = "maomao_2";
      
      public static const MAOMAO_3:String = "maomao_3";
      
      public static const NONO:String = "nono";
      
      public static const NONO_2:String = "nono2";
      
      public static const ZOG:String = "zog";
      
      public static const SEER_3:String = "seer_3";
      
      public static const BLACKSHADOW:String = "blackshadow";
      
      public static const SHAWN:String = "shawn";
      
      public static const DIEN:String = "dien";
      
      public static const DIEN_1:String = "dien_1";
      
      public static const DIEN_2:String = "dien_2";
      
      public static const NEWS:String = "news";
      
      public static const ELDER:String = "elder";
      
      public static const SNOWMAN_1:String = "snowman_1";
      
      public static const SNOWMAN_2:String = "snowman_2";
      
      public static const SNOWMAN_3:String = "snowman_3";
      
      public static const SNOWMAN_4:String = "snowman_4";
      
      public static const SNOWMAN_5:String = "snowman_5";
      
      public static const SNOWMAN_6:String = "snowman_6";
      
      public static const DINGGE:String = "dingge";
      
      public static const HUOYAN:String = "huoyan";
      
      public static const BEIER:String = "beier";
      
      public static const CACTI:String = "cacti";
      
      public static const BIBI:String = "bibi";
      
      public static const TONY:String = "tony";
      
      public static const SITUOLIYA:String = "situoliya";
      
      public static const BURKE:String = "burke";
      
      public static const DARKPET:String = "darkPet";
      
      public static const TonyAndB:String = "tonyAndB";
      
      public static const dalucher:String = "snowman_2";
      
      public static const ROCKY:String = "rocky";
      
      public static const LEAF:String = "leaf";
      
      public static const FLOWER:String = "flower";
      
      public static const MOSHIDILU:String = "moshidilu";
      
      public static const MILUPAPA:String = "milupapa";
      
      public static const MILUMAMA:String = "milumama";
      
      public static const MILUMAN:String = "miluman";
      
      public static const MILU:String = "milu";
      
      public static const MILU1:String = "milu1";
      
      public static const BURKE1:String = "burke1";
      
      public static const TONNIA:String = "tonnia";
      
      public static const DALU:String = "dalu";
      
      public static const HAMULEITE:String = "hamuleite";
      
      public static const ELONG:String = "elong";
      
      public static const MEATPET:String = "meatpet";
      
      public static const NEWPET:String = "newpet";
      
      public static const UNKNOWNPET:String = "blackHole";
      
      public static const NEWUNKNOWNPET:String = "unkonwnpet";
      
      public static const PIPI:String = "pipi";
      
      public function NpcTipDialog()
      {
         super();
      }
      
      public static function showList(a:Array, applayFun:Function = null) : void
      {
         var i:uint = 0;
         var npcs:String = null;
         var myShow:Function = function():void
         {
            if(a[1][i] == 0)
            {
               if(a[1][i - 1] != 0)
               {
                  npcs = a[1][i - 1];
               }
            }
            else
            {
               npcs = a[1][i];
            }
            show(a[0][i],function():void
            {
               if(i <= a.length - 1)
               {
                  ++i;
                  myShow();
               }
               else if(applayFun != null)
               {
                  applayFun();
               }
            },npcs,0,null,null,false);
         };
         i = 0;
         myShow();
      }
      
      public static function show(tipStr:String, applyFun:Function = null, npc:String = "", yPos:int = -60, exitFun:Function = null, cc:DisplayObjectContainer = null, exitable:Boolean = true) : MovieClip
      {
         var bgMC:Sprite;
         var tipTxt:TextField;
         var oreTip:MovieClip = null;
         var applyBtn:SimpleButton = null;
         var exitBtn:SimpleButton = null;
         var apply:Function = null;
         var onRemove:Function = null;
         apply = function(event:MouseEvent):void
         {
            DisplayUtil.removeForParent(oreTip);
            exitBtn.removeEventListener(MouseEvent.CLICK,onRemove);
            applyBtn.removeEventListener(MouseEvent.CLICK,apply);
            LevelManager.openMouseEvent();
            oreTip = null;
            dragMc = null;
            tipTxt = null;
            applyBtn = null;
            exitBtn = null;
            if(applyFun != null)
            {
               applyFun();
            }
         };
         onRemove = function(e:MouseEvent):void
         {
            if(!exitable)
            {
               apply(e);
               return;
            }
            LevelManager.openMouseEvent();
            exitBtn.removeEventListener(MouseEvent.CLICK,onRemove);
            applyBtn.removeEventListener(MouseEvent.CLICK,apply);
            DisplayUtil.removeForParent(oreTip);
            oreTip = null;
            dragMc = null;
            tipTxt = null;
            applyBtn = null;
            exitBtn = null;
            if(exitFun != null)
            {
               exitFun();
            }
         };
         oldStr = npc;
         oreTip = UIManager.getMovieClip("aliceDialog");
         var dragMc:SimpleButton = oreTip["dragMC"];
         dragMc.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            oreTip.startDrag();
         });
         dragMc.addEventListener(MouseEvent.MOUSE_UP,function():void
         {
            oreTip.stopDrag();
         });
         if(Boolean(cc))
         {
            cc.addChild(oreTip);
         }
         else
         {
            LevelManager.topLevel.addChild(oreTip);
         }
         bgMC = oreTip["bgMC"];
         oreTip.x = (MainManager.getStageWidth() - bgMC.width) / 2 - bgMC.x;
         oreTip.y = (MainManager.getStageHeight() - bgMC.height) / 2 - bgMC.y;
         LevelManager.closeMouseEvent();
         tipTxt = oreTip["dlogTxt"];
         tipTxt.htmlText = "    " + tipStr;
         if(npc == "")
         {
            npc = SHIPER;
         }
         trace("npc swf path:" + ClientConfig.getNpcSwfPath(npc));
         ResourceManager.getResource(ClientConfig.getNpcSwfPath(npc),function(o:DisplayObject):void
         {
            oreTip.addChild(o);
         },"npc");
         applyBtn = oreTip["okBtn"];
         exitBtn = oreTip["exitBtn"];
         applyBtn.addEventListener(MouseEvent.CLICK,apply);
         exitBtn.addEventListener(MouseEvent.CLICK,onRemove);
         return oreTip;
      }
      
      public static function showAnswer(tipStr:String, applyFun:Function = null, cancelFun:Function = null, npc:String = "", yPos:int = -60, cc:DisplayObjectContainer = null) : MovieClip
      {
         var btn:SimpleButton;
         var sprite:MovieClip = null;
         sprite = show(tipStr,applyFun,npc,yPos,cancelFun,cc);
         sprite["okBtn"].x = 209;
         sprite["okBtn"].y = 274;
         btn = UIManager.getButton("Cancel_Btn");
         sprite.addChild(btn);
         btn.width = 83;
         btn.height = 41;
         btn.x = 344;
         btn.y = 274;
         btn.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
         {
            LevelManager.openMouseEvent();
            DisplayUtil.removeForParent(sprite);
            if(cancelFun != null)
            {
               cancelFun();
            }
         });
         return sprite;
      }
   }
}

