package com.robot.app.task.taskUtils.taskDialog
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UIManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class DynamicNpcTipDialog
   {
      private static var oldStr:String;
      
      public function DynamicNpcTipDialog()
      {
         super();
      }
      
      public static function show(tipStr:String, applyFun:Function = null, npc:String = "", btn:InteractiveObject = null, exitFun:Function = null, cc:DisplayObjectContainer = null, exitable:Boolean = true) : MovieClip
      {
         var bgMC:Sprite;
         var tipTxt:TextField;
         var oreTip:MovieClip = null;
         var applyBtn:SimpleButton = null;
         var newBtn:InteractiveObject = null;
         var exitBtn:SimpleButton = null;
         var apply:Function = null;
         var onRemove:Function = null;
         apply = function(event:MouseEvent):void
         {
            DisplayUtil.removeForParent(oreTip);
            exitBtn.removeEventListener(MouseEvent.CLICK,onRemove);
            newBtn.removeEventListener(MouseEvent.CLICK,apply);
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
            npc = NpcTipDialog.SHIPER;
         }
         applyBtn = oreTip["okBtn"];
         DisplayUtil.removeForParent(applyBtn);
         if(!btn)
         {
            newBtn = new lib_be_vip_btn();
         }
         else
         {
            newBtn = btn;
         }
         newBtn.addEventListener(MouseEvent.CLICK,apply);
         DisplayUtil.align(newBtn,oreTip.getRect(oreTip),AlignType.BOTTOM_CENTER,new Point(0,-30));
         oreTip.addChild(newBtn);
         trace("npc swf path:" + ClientConfig.getNpcSwfPath(npc));
         ResourceManager.getResource(ClientConfig.getNpcSwfPath(npc),function(o:DisplayObject):void
         {
            oreTip.addChild(o);
         },"npc");
         exitBtn = oreTip["exitBtn"];
         exitBtn.addEventListener(MouseEvent.CLICK,onRemove);
         return oreTip;
      }
   }
}

