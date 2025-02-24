package com.robot.app.energy.ore
{
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.UIManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class OreAlertPanel
   {
      private static var oreTip:MovieClip;
      
      public function OreAlertPanel()
      {
         super();
      }
      
      public static function createOreAlert(tipStr:String, applyFun:Function = null, cancelFun:Function = null) : void
      {
         var dragMc:SimpleButton;
         var tipTxt:TextField;
         var exitBtn:SimpleButton = null;
         var applyBtn:SimpleButton = null;
         var cancelBtn:SimpleButton = null;
         var apply:Function = null;
         var cancel:Function = null;
         apply = function(event:MouseEvent):void
         {
            DisplayUtil.removeForParent(oreTip);
            exitBtn.removeEventListener(MouseEvent.CLICK,cancel);
            applyBtn.removeEventListener(MouseEvent.CLICK,apply);
            cancelBtn.removeEventListener(MouseEvent.CLICK,cancel);
            LevelManager.openMouseEvent();
            if(applyFun != null)
            {
               applyFun();
            }
         };
         cancel = function(event:MouseEvent):void
         {
            LevelManager.openMouseEvent();
            DisplayUtil.removeForParent(oreTip);
            exitBtn.removeEventListener(MouseEvent.CLICK,cancel);
            applyBtn.removeEventListener(MouseEvent.CLICK,apply);
            cancelBtn.removeEventListener(MouseEvent.CLICK,cancel);
            if(cancelFun != null)
            {
               cancelFun();
            }
         };
         if(oreTip == null)
         {
            oreTip = UIManager.getMovieClip("oreTipMc");
         }
         dragMc = oreTip["dragMC"];
         dragMc.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            oreTip.startDrag();
         });
         dragMc.addEventListener(MouseEvent.MOUSE_UP,function():void
         {
            oreTip.stopDrag();
         });
         LevelManager.topLevel.addChild(oreTip);
         DisplayUtil.align(oreTip,null,AlignType.MIDDLE_CENTER);
         LevelManager.closeMouseEvent();
         tipTxt = oreTip["tipTxt"];
         tipTxt.text = tipStr;
         exitBtn = oreTip["closeBtn"];
         exitBtn.addEventListener(MouseEvent.CLICK,cancel);
         applyBtn = oreTip["okBtn"];
         cancelBtn = oreTip["cancelBtn"];
         applyBtn.addEventListener(MouseEvent.CLICK,apply);
         cancelBtn.addEventListener(MouseEvent.CLICK,cancel);
      }
   }
}

